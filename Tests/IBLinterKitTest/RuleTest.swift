import IBLinterCore
import IBLinterKit
import XCTest

class RuleTest: XCTestCase {

    func testRelativeToMargin() {
        let path = "Tests/IBLinterKitTest/Resources/ConstraintTest.storyboard"
        let rule = Rules.RelativeToMarginRule.init()
        let violations = rule.validate(storyboard: StoryboardFile.init(path: path), swiftParser: .init(swiftFilePaths: []))
        XCTAssertEqual(violations.count, 4)
    }

    func testCustomClassName() {
        let path = "Tests/IBLinterKitTest/Resources/ViewControllerTest.storyboard"
        let rule = Rules.CustomClassNameRule.init()
        let violations = rule.validate(storyboard: StoryboardFile.init(path: path), swiftParser: .init(swiftFilePaths: []))
        XCTAssertEqual(violations.count, 1)
    }

    func testDuplicateConstraint() {
        let path = "Tests/IBLinterKitTest/Resources/DuplicateConstraint.xib"
        let rule = Rules.DuplicateConstraintRule.init()
        let violations = rule.validate(xib: XibFile.init(path: path), swiftParser: .init(swiftFilePaths: []))
        XCTAssertEqual(violations.count, 2)
    }

    func testOutletConnection() {
        let path = "Tests/IBLinterKitTest/Resources/IBConnectionViewController.storyboard"
        let storyboard = StoryboardFile.init(path: path)
        let document = storyboard.document

        let cache = Rules.OutletConnectionRule.Mapper.init(storyboardDocument: document)
        XCTAssertEqual(cache.idToClassName["Ksm-ni-UfK"], "IBConnectionViewController")
        let classNameToConnection: [InterfaceBuilderNode.View.Connection] = [
            .outlet(property: "label", destination: "4Kb-9I-U6T", id: "pIv-Ri-ced"),
            .outletCollection(property: "buttons", destination: "8xx-RP-XBa", collectionClass: "NSMutableArray", id: "lRk-MP-xW4"),
            .outletCollection(property: "buttons", destination: "Ulz-qw-r0G", collectionClass: "NSMutableArray", id: "IWl-Al-b0P"),
            .outletCollection(property: "buttons", destination: "nuQ-9T-S11", collectionClass: "NSMutableArray", id: "pVK-zw-QQZ"),
            .outletCollection(property: "buttons", destination: "XnY-el-17d", collectionClass: "NSMutableArray", id: "Ogn-7z-bU1"),
            .action(selector: "touchUpInsideAction:", destination: "Ksm-ni-UfK", eventType: "touchUpInside", id: "soG-Tt-FV9"),
        ]

        XCTAssertEqual(cache.classNameToConnection["IBConnectionViewController"]!, classNameToConnection)

        let rule = Rules.OutletConnectionRule.init()
        let swiftParser = SwiftIBParser.init(swiftFilePaths: ["Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift"])
        let violations = rule.validate(storyboard: storyboard, swiftParser: swiftParser)
        XCTAssertEqual(violations.count, 2)
    }

}

