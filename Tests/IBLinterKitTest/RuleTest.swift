import IBDecodable
@testable import IBLinterKit
import XCTest

class RuleTest: XCTestCase {

    func testRelativeToMargin() {
        let path = "Tests/IBLinterKitTest/Resources/ConstraintTest.storyboard"
        let rule = Rules.RelativeToMarginRule.init()
        let violations = try! rule.validate(storyboard: StoryboardFile.init(path: path))
        XCTAssertEqual(violations.count, 4)
    }

    func testCustomClassName() {
        let path = "Tests/IBLinterKitTest/Resources/ViewControllerTest.storyboard"
        let rule = Rules.CustomClassNameRule.init()
        let violations = try! rule.validate(storyboard: StoryboardFile.init(path: path))
        XCTAssertEqual(violations.count, 1)
    }

    func testDuplicateConstraint() {
        let path = "Tests/IBLinterKitTest/Resources/DuplicateConstraint.xib"
        let rule = Rules.DuplicateConstraintRule.init()
        let violations = try! rule.validate(xib: XibFile.init(path: path))
        XCTAssertEqual(violations.count, 2)
    }

    func testDefaultEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: [], enabledRules: [], excluded: [], reporter: "xcode")
        let rules = Rules.rules(config)
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(defaultEnabledRules))
        XCTAssertEqual(rules.count, defaultEnabledRules.count)
    }

    func testDisableDefaultEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: [], excluded: [], reporter: "xcode")
        let rules = Rules.rules(config)
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set())
        XCTAssertEqual(rules.count, 0)
    }

    func testDuplicatedEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: [], enabledRules: defaultEnabledRules, excluded: [], reporter: "xcode")
        let rules = Rules.rules(config)
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(defaultEnabledRules))
        XCTAssertEqual(rules.count, defaultEnabledRules.count)
    }
}
