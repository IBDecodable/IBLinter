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
}

