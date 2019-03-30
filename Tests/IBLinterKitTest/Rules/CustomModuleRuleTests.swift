//
//  CustomModuleRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class CustomModuleRuleTests: XCTestCase {

    let fixture = Fixture()

    func testCustomModule() {
        let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
        let projectMockPath = "Resources/Rules/CustomModuleRule/ProjectMock"
        let config = Config(
            disabledRules: defaultEnabledRules,
            enabledRules: ["custom_module"],
            excluded: [], included: [],
            customModuleRule: [
                CustomModuleConfig(
                    module: "TestCustomModule",
                    included: [fixture.path(projectMockPath).path],
                    excluded: [fixture.path("\(projectMockPath)/CustomModuleExcluded").path]
                )
            ],
            baseClassRule: [],
            reporter: "xcode"
        )
        let rule = Rules.CustomModuleRule(context: .mock(from: config))
        let ngUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 1)
        let okUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
    }
}
