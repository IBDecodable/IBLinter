//
//  File.swift
//  
//
//  Created by Mark Fernandez on 2/19/20.
//

@testable import IBLinterKit
import XCTest

class UseColorRuleTests: XCTestCase {

    let fixture = Fixture()

    func testColorProperties() {
        let url = fixture.path("Resources/Rules/ColorResourcesRule/ColorResources.xib")
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let config = Config(disabledRules: defaultEnabledRules, enabledRules: [], excluded: [], included: [], customModuleRule: [], colorRule: [UseColorConfig(allowedColors: ["black", "blue"])], reporter: "xcode")
        let rule = Rules.UseColorRule(context: .mock(from: config))
        let violations = try! rule.validate(xib: .init(url: url))
        XCTAssertEqual(violations.count, 1)
    }
}
