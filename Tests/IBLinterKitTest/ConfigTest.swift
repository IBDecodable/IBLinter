import IBLinterKit
import XCTest

class ConfigTest: XCTest {

    func testConfigFile() throws {
        let config = try Config.load(from: "./Tests/IBLinterKitTest/Resources/.iblinter")
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, ["relative_to_margin"])
        XCTAssertEqual(config.excluded, ["Carthage"])
    }
}
