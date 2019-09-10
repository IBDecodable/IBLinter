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
    let defaultEnabledRules = Rules.defaultRules.map({ $0.identifier })
    let projectMockPath = "Resources/Rules/CustomModuleRule/ProjectMock"
    
    private func makeConfig(included: [String], excluded: [String]) -> Config {
        return Config(
            disabledRules: defaultEnabledRules,
            enabledRules: ["custom_module"],
            excluded: [], included: [],
            customModuleRule: [
                CustomModuleConfig(
                    module: "TestCustomModule",
                    included: included,
                    excluded: excluded
                )
            ],
            baseClassRule: [],
            reporter: "xcode"
        )
    }
    
    func testCustomModule() {
        let config = makeConfig(
            included: [fixture.path(projectMockPath).path],
            excluded: [fixture.path("\(projectMockPath)/CustomModuleExcluded").path]
        )
        let rule = Rules.CustomModuleRule(context: .mock(from: config))
        let ngUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 2)
        let okUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
        let storyboardNgUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.storyboard")
        let storyboardNgViolations = try! rule.validate(storyboard: StoryboardFile(url: storyboardNgUrl))
        XCTAssertEqual(storyboardNgViolations.count, 1)
        let storyboardOkUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.storyboard")
        let storyboardOkViolations = try! rule.validate(storyboard: StoryboardFile(url: storyboardOkUrl))
        XCTAssertEqual(storyboardOkViolations.count, 0)
    }
    
    func testCustomModuleWithRelativePath() {
        let config = makeConfig(
            included: ["Tests/IBLinterKitTest/\(projectMockPath)"],
            excluded: ["Tests/IBLinterKitTest/\(projectMockPath)/CustomModuleExcluded"]
        )
        let rule = Rules.CustomModuleRule(context: .mock(from: config))
        let ngUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: ngUrl))
        XCTAssertEqual(ngViolations.count, 2)
        let okUrl = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okUrl))
        XCTAssertEqual(okViolations.count, 0)
    }
}
