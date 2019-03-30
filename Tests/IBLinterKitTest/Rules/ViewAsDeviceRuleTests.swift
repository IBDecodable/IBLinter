//
//  ViewAsDeviceRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class ViewAsDeviceRuleTests: XCTestCase {

    let fixture = Fixture()

    func testViewAsDeviceWithNoConfig() {
        let ngUrl = fixture.path("Resources/Rules/ViewAsDeviceRule/ViewAsRetina6_5Test.storyboard")
        let ngRule = Rules.ViewAsDeviceRule(context: .mock(from: .default))
        let ngViolations = try! ngRule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = fixture.path("Resources/Rules/ViewAsDeviceRule/ViewAsRetina4_7Test.storyboard")
        let okRule = Rules.ViewAsDeviceRule(context: .mock(from: .default))
        let okViolations = try! okRule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
    }

    func testViewAsDeviceWithConfig() {
        let config = Config(viewAsDeviceRule: ViewAsDeviceConfig(deviceId: "retina4_0"))
        let ngUrl = fixture.path("Resources/Rules/ViewAsDeviceRule/ViewAsRetina6_5Test.storyboard")
        let ngRule = Rules.ViewAsDeviceRule(context: .mock(from: config))
        let ngViolations = try! ngRule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = fixture.path("Resources/Rules/ViewAsDeviceRule/ViewAsRetina4_0Test.storyboard")
        let okRule = Rules.ViewAsDeviceRule(context: .mock(from: config))
        let okViolations = try! okRule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
    }
}
