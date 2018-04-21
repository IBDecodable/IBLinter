import XCTest
import IBDecodable
import IBLinterKit
import SWXMLHash

class InterfaceBuilderParserTest: XCTestCase {

    private lazy var parser: InterfaceBuilderParser = {
        return InterfaceBuilderParser()
    }()

    private func xmlString(fileName: String) -> String {
        let url = URL.init(fileURLWithPath: "Tests/IBLinterKitTest/Resources/\(fileName)")
        return try! String.init(contentsOf: url)
    }

    func testParseViewController() throws {
        let document = try parser.parseStoryboard(xml: xmlString(fileName: "ViewControllerTest.storyboard"))
        let viewController = document.scenes![0].viewController!.viewController as! ViewController
        XCTAssertEqual(viewController.id, "uo8-pZ-S8b")

        let view = viewController.view!
        XCTAssertEqual(view.id, "EHN-qE-V0Y")
        XCTAssertEqual(view.contentMode, "scaleToFill")
        XCTAssertEqual(view.subviews?.count, 4)

        let button: Button = {
            guard let button = view.subviews![0].view as? Button else {
                fatalError()
            }
            return button
        }()

        func buttonState(for key: String) -> Button.State? {
            return button.state?.first(where: { $0.key == key })
        }

        let normalTextColor = buttonState(for: "normal")?.color?.sRGB

        XCTAssertEqual(buttonState(for: "normal")?.title, "Default Title")
        XCTAssertEqual(buttonState(for: "selected")?.title, "Selected Title")
        XCTAssertEqual(buttonState(for: "highlighted")?.title, "Highlighted Title")
        XCTAssertEqual(buttonState(for: "disabled")?.title, "Disabled Title")
        XCTAssertEqual(normalTextColor?.red, 0.97647058819999999)
        XCTAssertEqual(normalTextColor?.green, 0.25882352939999997)
        XCTAssertEqual(normalTextColor?.blue, 0.24313725489999999)
        XCTAssertEqual(normalTextColor?.key, "titleColor")

        let label: Label = {
            guard let label = view.subviews![1].view as? Label else {
                fatalError()
            }
            return label
        }()
        XCTAssertEqual(label.text, "Label")
        XCTAssertEqual(label.adjustsFontSizeToFit, false)

        let segmentedControl: SegmentedControl = {
            guard let control = view.subviews![2].view as? SegmentedControl else {
                fatalError()
            }
            return control
        }()
        XCTAssertEqual(segmentedControl.segmentControlStyle, "plain")
        XCTAssertEqual(segmentedControl.segments[0].title, "First")

        let textField: TextField = {
            guard let textField = view.subviews![3].view as? TextField else {
                fatalError()
            }
            return textField
        }()

        XCTAssertEqual(textField.fontDescription?.pointSize, 14)
        XCTAssertEqual(textField.fontDescription?.type, "system")
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
        let cell: TableViewCell = {
            guard let cell = document.views![0].view as? TableViewCell else {
                fatalError()
            }
            return cell
        }()

        XCTAssertEqual(cell.subviews?.count, 1)
    }

    func testXMLFormatValidator() {
        do {
            _ = try parser.parseXib(xml: xmlString(fileName: "MacXibTest.xib"))
            XCTFail("should throw error")
        } catch _ as InterfaceBuilderParser.Error {
            XCTAssertTrue(true)
        } catch {
            XCTFail("wrong error")
        }
    }
}
