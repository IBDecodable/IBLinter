import IBDecodable
@testable import IBLinterKit
import XCTest

extension Context {
    static func mock(from config: Config) -> Context {
        let workDirectory = URL(fileURLWithPath: #file)
            .deletingLastPathComponent() // ./Tests/IBLinterKitTests/Rules
            .deletingLastPathComponent() // ./Tests/IBLinterKitTests
            .deletingLastPathComponent() // ./Tests
            .deletingLastPathComponent() // ./
        return Context(
            config: config,
            workDirectory: workDirectory,
            externalRules: []
        )
    }
}

class RuleTests: XCTestCase {

    func context(from config: Config) -> Context {
        return Context.init(config: config, workDirectory: URL(string: FileManager.default.currentDirectoryPath)!, externalRules: [])
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

}
