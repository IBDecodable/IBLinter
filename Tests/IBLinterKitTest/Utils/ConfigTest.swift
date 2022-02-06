import IBLinterKit
import XCTest

class ConfigTest: XCTestCase {

    let fixture = Fixture()

    func testConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter.yml")
        let config = try Config(url: url)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, ["relative_to_margin"])
        XCTAssertEqual(config.excluded, ["Carthage"])
        XCTAssertEqual(config.reporter, "json")
    }

    func testNullableConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter_nullable.yml")
        let config = try Config(url: url)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, [])
        XCTAssertEqual(config.excluded, ["Carthage"])
    }

    func testViewAsDeviceConfigFile() throws {
        let url = fixture.path("Resources/Config/.iblinter_view_as_device.yml")
        let config = try Config(url: url)
        XCTAssertNotNil(config.viewAsDeviceRule)
        XCTAssertEqual(config.viewAsDeviceRule?.deviceId, "retina3_5")
    }
}
