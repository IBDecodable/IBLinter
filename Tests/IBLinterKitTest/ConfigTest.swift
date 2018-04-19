import IBLinterKit
import XCTest

class ConfigTest: XCTestCase {

    func testConfigFile() throws {
        let config = try Config.load(from: "./Tests/IBLinterKitTest/Resources/")
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, ["relative_to_margin"])
        XCTAssertEqual(config.excluded, ["Carthage"])
        XCTAssertEqual(config.reporter, "json")
    }

    func testNullableConfigFile() throws {
        let config = try Config.load(from: "./Tests/IBLinterKitTest/Resources/", fileName: ".iblinter_nullable.yml")
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, [])
        XCTAssertEqual(config.excluded, ["Carthage"])
    }
}
