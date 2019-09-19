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
        let ngURL = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: ngURL))
        XCTAssertEqual(ngViolations.count, 2)
        let okURL = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okURL))
        XCTAssertEqual(okViolations.count, 0)
        let storyboardNGURL = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.storyboard")
        let storyboardNGViolations = try! rule.validate(storyboard: StoryboardFile(url: storyboardNGURL))
        XCTAssertEqual(storyboardNGViolations.count, 1)
        let storyboardOKURL = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.storyboard")
        let storyboardOKViolations = try! rule.validate(storyboard: StoryboardFile(url: storyboardOKURL))
        XCTAssertEqual(storyboardOKViolations.count, 0)
    }
    
    func testCustomModuleWithRelativePath() {
        let config = makeConfig(
            included: ["Tests/IBLinterKitTest/\(projectMockPath)"],
            excluded: ["Tests/IBLinterKitTest/\(projectMockPath)/CustomModuleExcluded"]
        )
        let rule = Rules.CustomModuleRule(context: .mock(from: config))
        let ngURL = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleNGTest.xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: ngURL))
        XCTAssertEqual(ngViolations.count, 2)
        let okURL = fixture.path("Resources/Rules/CustomModuleRule/CustomModuleOKTest.xib")
        let okViolations = try! rule.validate(xib: XibFile(url: okURL))
        XCTAssertEqual(okViolations.count, 0)
    }

    func testSameNameClass() {
        let config = Config(
            disabledRules: defaultEnabledRules,
            enabledRules: ["custom_module"],
            excluded: [], included: [],
            customModuleRule: [
                CustomModuleConfig(
                    module: "ModuleA",
                    included: ["Tests/IBLinterKitTest/Resources/Rules/CustomModuleRule/SameNameClass/ModuleA"],
                    excluded: []
                ),
                CustomModuleConfig(
                    module: "ModuleB",
                    included: ["Tests/IBLinterKitTest/Resources/Rules/CustomModuleRule/SameNameClass/ModuleB"],
                    excluded: []
                ),
            ],
            baseClassRule: [],
            reporter: "xcode"
        )

        let rule = Rules.CustomModuleRule(context: .mock(from: config))
        let fileURL = fixture.path("Resources/Rules/CustomModuleRule/SameNameClass/TestView.xib")
        let ngViolations = try! rule.validate(xib: XibFile(url: fileURL))
        XCTAssertEqual(ngViolations.count, 0)
    }
}
