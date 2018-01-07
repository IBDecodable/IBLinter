import IBLinterCore
import IBLinterKit
import XCTest

class RuleTest: XCTestCase {

    func testRelativeToMargin() {
        let path = "Tests/IBLinterKitTest/Resources/ConstraintTest.storyboard"
        let rule = Rules.RelativeToMarginRule.init()
        let violations = rule.validate(storyboard: StoryboardFile.init(path: path))
        XCTAssertEqual(violations.count, 4)
    }

    func testCustomClassName() {
        let path = "Tests/IBLinterKitTest/Resources/ViewControllerTest.storyboard"
        let rule = Rules.CustomClassNameRule.init()
        let violations = rule.validate(storyboard: StoryboardFile.init(path: path))
        XCTAssertEqual(violations.count, 1)
    }

    func testDuplicateConstraint() {
        let path = "Tests/IBLinterKitTest/Resources/DuplicateConstraint.xib"
        let rule = Rules.DuplicateConstraintRule.init()
        let violations = rule.validate(xib: XibFile.init(path: path))
        XCTAssertEqual(violations.count, 2)
    }

    func testOutletConnection() {
        let path = "Tests/IBLinterKitTest/Resources/OutletTest.storyboard"
        let storyboard = StoryboardFile.init(path: path)
        guard let viewController = storyboard.document.scenes?.first?.viewController else { return }

        let cache = Rules.OutletConnectionRule.Mapper.init(viewController: viewController)
        XCTAssertEqual(cache.idToClassName, ["Ksm-ni-UfK": "OutletTest"])
        let classNameToConnection: [InterfaceBuilderNode.View.Connection] = [
            .outlet(property: "label", destination: "4Kb-9I-U6T", id: "pIv-Ri-ced"),
            .outletCollection(property: "buttons", destination: "8xx-RP-XBa", collectionClass: "NSMutableArray", id: "lRk-MP-xW4"),
            .outletCollection(property: "buttons", destination: "Ulz-qw-r0G", collectionClass: "NSMutableArray", id: "IWl-Al-b0P"),
            .outletCollection(property: "buttons", destination: "nuQ-9T-S11", collectionClass: "NSMutableArray", id: "pVK-zw-QQZ"),
            .outletCollection(property: "buttons", destination: "XnY-el-17d", collectionClass: "NSMutableArray", id: "Ogn-7z-bU1"),
            .action(selector: "touchUpInsideAction:", destination: "Ksm-ni-UfK", eventType: "touchUpInside", id: "soG-Tt-FV9"),
        ]

        XCTAssertEqual(cache.classNameToConnection["OutletTest"]!, classNameToConnection)
    }

    func testSwiftIBParser() {
        let path = "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift"
        let swiftParser = SwiftIBParser(swiftFilePaths: [path])

        let classStructure = SwiftIBParser.Class(
            name: "IBConnectionViewController",
            outlets: [
                SwiftIBParser.Declaration(
                    name: "label", line: 5, column: 23,
                    url: URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift").absoluteURL,
                    isOptional: false
                ),
                SwiftIBParser.Declaration(
                    name: "buttons", line: 6, column: 23,
                    url: URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift").absoluteURL,
                    isOptional: false
                )
            ],
            actions: [
                SwiftIBParser.Declaration(
                    name: "touchUpInsideAction:", line: 8, column: 19,
                    url: URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift").absoluteURL,
                    isOptional: false
                )
            ]
        )
        XCTAssertEqual(swiftParser.classNameToStructure, ["IBConnectionViewController": classStructure])
    }
}

