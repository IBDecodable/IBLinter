import IBLinterKit
import XCTest

class ConfigTest: XCTestCase {

    func testConfigFile() throws {
        let url = self.url(forResource: ".iblinter", withExtension: "yml")
        let config = try Config.load(from: url)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, ["relative_to_margin"])
        XCTAssertEqual(config.excluded, ["Carthage"])
        XCTAssertEqual(config.reporter, "json")
    }

    func testNullableConfigFile() throws {
        let url = self.url(forResource: ".iblinter_nullable", withExtension: "yml")
        let config = try Config.load(from: url)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, [])
        XCTAssertEqual(config.excluded, ["Carthage"])
    }
}
