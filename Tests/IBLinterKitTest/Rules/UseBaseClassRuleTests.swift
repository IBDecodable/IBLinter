//
//  UseBaseClassRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class UseBaseClassRuleTests: XCTestCase {

    let fixture = Fixture()

    func testUseBaseClass() {
        let url = fixture.path("Resources/Rules/UseBaseClassRule/UseBaseClassTest.xib")
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: [], excluded: [], included: [], customModuleRule: [], baseClassRule: [UseBaseClassConfig(elementClass: "UILabel", baseClasses: ["PrimaryLabel", "SecondaryLabel"])], reporter: "xcode")
        let rule = Rules.UseBaseClassRule(context: .mock(from: config))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }
}
