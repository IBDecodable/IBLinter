import IBDecodable
@testable import IBLinterKit
import XCTest

class RuleTest: XCTestCase {

    func context(from config: Config) -> Context {
        return Context.init(config: config, workDirectory: URL(string: FileManager.default.currentDirectoryPath)!, externalRules: [])
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
        let config = Config(disabledRules: [], enabledRules: [], excluded: [], included: [], customModuleRule: [], baseClassRule: [], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(defaultEnabledRules))
        XCTAssertEqual(rules.count, defaultEnabledRules.count)
    }

    func testDisableDefaultEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: [], excluded: [], included: [], customModuleRule: [], baseClassRule: [], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set())
        XCTAssertEqual(rules.count, 0)
    }

    func testDuplicatedEnabledRules() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: [], enabledRules: defaultEnabledRules, excluded: [], included: [], customModuleRule: [], baseClassRule: [], reporter: "xcode")
        let rules = Rules.rules(context(from: config))
        XCTAssertEqual(Set(rules.map({ type(of:$0).identifier })), Set(defaultEnabledRules))
        XCTAssertEqual(rules.count, defaultEnabledRules.count)
    }

    func testImageResources() {
        let url = self.url(forResource: "StoryboardAsset", withExtension: "storyboard")
        let assetURL = self.url(forResource: "Media", withExtension: "xcassets")
        let rule = Rules.ImageResourcesRule(catalogs: [.init(path: assetURL.path)])
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 3)
    }

    func testCustomModule() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: ["custom_module"], excluded: [], included: [], customModuleRule: [CustomModuleConfig(module: "TestCustomModule", included: ["Tests/IBLinterKitTest/Resources/TestCustomModule"], excluded: ["Tests/IBLinterKitTest/Resources/TestCustomModule/CustomModuleExcluded"])], baseClassRule: [], reporter: "xcode")
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

    func testAmbiguous() {
        let url = self.url(forResource: "AmbiguousConstraint", withExtension: "storyboard")
        let rule = Rules.AmbiguousViewRule(context: context(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }

    func testUseBaseClass() {
        let url = self.url(forResource: "UseBaseClassTest", withExtension: "xib")
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: [], excluded: [], included: [], customModuleRule: [], baseClassRule: [UseBaseClassConfig(elementClass: "UILabel", baseClasses: ["PrimaryLabel", "SecondaryLabel"])], reporter: "xcode")
        let rule = Rules.UseBaseClassRule(context: context(from: config))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }

    func testViewAsDeviceWithNoConfig() {
        let ngUrl = self.url(forResource: "ViewAsRetina6_5Test", withExtension: "storyboard")
        let ngRule = Rules.ViewAsDeviceRule(context: context(from: .default))
        let ngViolations = try! ngRule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = self.url(forResource: "ViewAsRetina4_7Test", withExtension: "storyboard")
        let okRule = Rules.ViewAsDeviceRule(context: context(from: .default))
        let okViolations = try! okRule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
    }

    func testViewAsDeviceWithConfig() {
        let config = Config(viewAsDeviceRule: ViewAsDeviceConfig(deviceId: "retina4_0"))
        let ngUrl = self.url(forResource: "ViewAsRetina6_5Test", withExtension: "storyboard")
        let ngRule = Rules.ViewAsDeviceRule(context: context(from: config))
        let ngViolations = try! ngRule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = self.url(forResource: "ViewAsRetina4_0Test", withExtension: "storyboard")
        let okRule = Rules.ViewAsDeviceRule(context: context(from: config))
        let okViolations = try! okRule.validate(xib: XibFile(url: okUrl))
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
