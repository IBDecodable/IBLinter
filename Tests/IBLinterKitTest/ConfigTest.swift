import IBLinterKit
import XCTest

class ConfigTest: XCTestCase {

    func testConfigFile() throws {
        let url = self.url(forResource: ".iblinter", withExtension: "yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config.load(from: workingDirectory)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, ["relative_to_margin"])
        XCTAssertEqual(config.excluded, ["Carthage"])
        XCTAssertEqual(config.reporter, "json")
    }

    func testNullableConfigFile() throws {
        let url = self.url(forResource: ".iblinter_nullable", withExtension: "yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config.load(from: workingDirectory, fileName: url.lastPathComponent)
        XCTAssertEqual(config.disabledRules, ["custom_class_name"])
        XCTAssertEqual(config.enabledRules, [])
        XCTAssertEqual(config.excluded, ["Carthage"])
    }

    func testViewAsDeviceConfigFile() throws {
        let url = self.url(forResource: ".iblinter_view_as_device", withExtension: "yml")
        let workingDirectory = url.deletingLastPathComponent()
        let config = try Config.load(from: workingDirectory, fileName: url.lastPathComponent)
        XCTAssertNotNil(config.viewAsDeviceRule)
        XCTAssertEqual(config.viewAsDeviceRule?.deviceId, "retina3_5")
    }
}
