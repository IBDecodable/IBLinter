import IBDecodable
@testable import IBLinterKit
import XCTest

class RuleTest: XCTestCase {

    func testRelativeToMargin() {
        let url = self.url(forResource: "ConstraintTest", withExtension: "storyboard")
        let rule = Rules.RelativeToMarginRule()
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 4)
    }

    func testCustomClassName() {
        let url = self.url(forResource: "ViewControllerTest", withExtension: "storyboard")
        let rule = Rules.CustomClassNameRule()
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }

    func testDuplicateConstraint() {
        let url = self.url(forResource: "DuplicateConstraint", withExtension: "xib")
        let rule = Rules.DuplicateConstraintRule()
        let violations = try! rule.validate(xib: XibFile(url: url))
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

// MARK: resource utils

extension XCTestCase {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    func url(forResource resource: String, withExtension ext: String) -> URL {
        if let url = bundle.url(forResource: resource, withExtension: ext) {
            return url
        }
        return URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/\(resource).\(ext)")
    }
    
    func xmlString(forResource resource: String, withExtension ext: String) -> String {
        let url = self.url(forResource: resource, withExtension: ext)
        return try! String.init(contentsOf: url)
    }
}
