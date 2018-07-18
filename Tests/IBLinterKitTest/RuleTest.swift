import IBDecodable
@testable import IBLinterKit
import XCTest

class RuleTest: XCTestCase {

    func context(from config: Config) -> Context {
        return Context.init(config: config, workDirectory: FileManager.default.currentDirectoryPath)
    }

    func testRelativeToMargin() {
        let url = self.url(forResource: "ConstraintTest", withExtension: "storyboard")
        let rule = Rules.RelativeToMarginRule(context: context(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 4)
    }

    func testCustomClassName() {
        let url = self.url(forResource: "ViewControllerTest", withExtension: "storyboard")
        let rule = Rules.CustomClassNameRule(context: context(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }

    func testDuplicateConstraint() {
        let url = self.url(forResource: "DuplicateConstraint", withExtension: "xib")
        let rule = Rules.DuplicateConstraintRule(context: context(from: .default))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }

    func testDefaultEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: [], enabledRules: [], excluded: [], customModuleRule: [], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(defaultEnabledRules))
        XCTAssertEqual(rules.count, defaultEnabledRules.count)
    }

    func testDisableDefaultEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: [], excluded: [], customModuleRule: [], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set())
        XCTAssertEqual(rules.count, 0)
    }

    func testDuplicatedEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: [], enabledRules: defaultEnabledRules, excluded: [], customModuleRule: [], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(defaultEnabledRules))
        XCTAssertEqual(rules.count, defaultEnabledRules.count)
    }

    func testImageResources() {
        let url = self.url(forResource: "StoryboardAsset", withExtension: "storyboard")
        let assetURL = self.url(forResource: "Media", withExtension: "xcassets")
        let rule = Rules.ImageResourcesRule(catalogs: [.init(path: assetURL.path)])
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }

    func testCustomModule() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: ["custom_module"], excluded: [], customModuleRule: [CustomModuleConfig(module: "TestCustomModule", included: ["Tests/IBLinterKitTest/Resources/TestCustomModule"], excluded: ["Tests/IBLinterKitTest/Resources/TestCustomModule/CustomModuleExcluded"])], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(["custom_module"]))
        let rule = rules[0]
        let ngUrl = self.url(forResource: "CustomModuleNGTest", withExtension: "xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = self.url(forResource: "CustomModuleOKTest", withExtension: "xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
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
