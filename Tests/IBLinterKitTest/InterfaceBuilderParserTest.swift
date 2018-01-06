import XCTest
import IBLinterCore
import IBLinterKit
import SWXMLHash

class InterfaceBuilderParserTest: XCTestCase {

    private lazy var parser: InterfaceBuilderParser = {
        return InterfaceBuilderParser.init(with: SWXMLHash.config { _ in })
    }()

    private func xmlString(fileName: String) -> String {
        let url = URL.init(fileURLWithPath: "Tests/IBLinterKitTest/Resources/\(fileName)")
        return try! String.init(contentsOf: url)
    }

    func testParseViewController() throws {
        let document = try parser.parseStoryboard(xml: xmlString(fileName: "ViewControllerTest.storyboard"))
        let viewController = document.scenes![0].viewController!
        XCTAssertEqual(viewController.id, "uo8-pZ-S8b")
        
        let view = viewController.viewController!.view!
        XCTAssertEqual(view.id, "EHN-qE-V0Y")
        XCTAssertEqual(view.contentMode, "scaleToFill")
        XCTAssertEqual(view.subviews?.count, 4)

        let button: InterfaceBuilderNode.View.Button = {
            switch view.subviews![0] {
            case .button(let button): return button
            default: fatalError()
            }
        }()
        XCTAssertEqual(button.title.normal, "Default Title")
        XCTAssertEqual(button.title.selected, "Selected Title")
        XCTAssertEqual(button.title.highlighted, "Highlighted Title")
        XCTAssertEqual(button.title.disabled, "Disabled Title")
        XCTAssertEqual(button.textColor.normal?.sRGB?.red, 0.97647058819999999)
        XCTAssertEqual(button.textColor.normal?.sRGB?.green, 0.25882352939999997)
        XCTAssertEqual(button.textColor.normal?.sRGB?.blue, 0.24313725489999999)
        XCTAssertEqual(button.textColor.normal?.sRGB?.key, "titleColor")

        let label: InterfaceBuilderNode.View.Label = {
            switch view.subviews![1] {
            case .label(let label): return label
            default: fatalError()
            }
        }()
        XCTAssertEqual(label.text, "Label")
        XCTAssertEqual(label.adjustsFontSizeToFit, false)

        let segmentedControl: InterfaceBuilderNode.View.SegmentedControl = {
            switch view.subviews![2] {
            case .segmentedControl(let segmentedControl): return segmentedControl
            default: fatalError()
            }
        }()
        XCTAssertEqual(segmentedControl.segmentControlStyle, "plain")
        XCTAssertEqual(segmentedControl.segments[0].title, "First")

        let textField: InterfaceBuilderNode.View.TextField = {
            switch view.subviews![3] {
            case .textField(let textField): return textField
            default: fatalError()
            }
        }()

        XCTAssertEqual(textField.font?.pointSize, 14)
        XCTAssertEqual(textField.font?.type, "system")
        XCTAssertEqual(textField.borderStyle, "roundedRect")
    }

    func testParseDocument() throws {

        let document = try parser.parseStoryboard(xml: xmlString(fileName: "ViewControllerTest.storyboard"))
        XCTAssertEqual(document.type, "com.apple.InterfaceBuilder3.CocoaTouch.Storyboard.XIB")
        XCTAssertEqual(document.version, "3.0")
        XCTAssertEqual(document.toolsVersion, "13196")
        XCTAssertEqual(document.targetRuntime, "iOS.CocoaTouch")
        XCTAssertEqual(document.propertyAccessControl, "none")
        XCTAssertEqual(document.useAutolayout, true)
        XCTAssertEqual(document.useTraitCollections, true)
        XCTAssertEqual(document.useSafeAreas, true)
        XCTAssertEqual(document.colorMatched, true)
    }

    func testParseDevice() throws {
        let document = try parser.parseStoryboard(xml: xmlString(fileName: "ViewControllerTest.storyboard"))
        XCTAssertEqual(document.device?.id, "retina4_7")
        XCTAssertEqual(document.device?.orientation, "portrait")
        XCTAssertEqual(document.device?.adaptation, "fullscreen")
    }

    func testParseXib() throws {
        let document = try parser.parseXib(xml: xmlString(fileName: "ViewTest.xib"))
        XCTAssertEqual(document.views?.count, 2)
        XCTAssertNotNil(document.views)
    }

    func testParseTableViewCell() throws {
        let document = try parser.parseXib(xml: xmlString(fileName: "TableViewCell.xib"))
        let cell: InterfaceBuilderNode.View.TableViewCell = {
            switch document.views![0] {
            case .tableViewCell(let cell): return cell
            default: fatalError()
            }
        }()

        XCTAssertEqual(cell.subviews?.count, 1)
    }

    func testParseOutlet() throws {
        let document = try parser.parseStoryboard(xml: xmlString(fileName: "OutletTest.storyboard"))
        XCTAssertNotNil(document.scenes?[0].viewController?.rootView)

        let viewController = document.scenes![0].viewController!
        XCTAssertEqual(viewController.connections?.count, 5)

        let labelOutlet = viewController.connections![0]
        switch labelOutlet {
        case .outlet(let property, let destination, let id):
            XCTAssertEqual(property, "label")
            XCTAssertEqual(destination, "4Kb-9I-U6T")
            XCTAssertEqual(id, "pIv-Ri-ced")
        default: fatalError()
        }

        let button = viewController.rootView!.subviews!.first(where: { $0.id == "8M7-on-UR7" })!
        XCTAssertEqual(button.connections?.count, 1)

        let actionOutlet = button.connections![0]
        switch actionOutlet {
        case .action(let selector, let destination, let eventType, let id):
            XCTAssertEqual(selector, "touchUpInsideAction:")
            XCTAssertEqual(destination, "Ksm-ni-UfK")
            XCTAssertEqual(eventType, "touchUpInside")
            XCTAssertEqual(id, "soG-Tt-FV9")
        default: fatalError()
        }
    }

    func testFindView() throws {
        let document = try parser.parseXib(xml: xmlString(fileName: "ViewTest.xib"))
        let view = document.views![0]
        let matchedView = view.find(by: "TSs-N3-WO3")
        XCTAssertNotNil(matchedView)
        let button: InterfaceBuilderNode.View.Button = {
            switch matchedView! {
            case .button(let button):
                return button
            default: fatalError()
            }
        }()
        XCTAssertEqual(button.buttonType, "roundedRect")
    }
}
