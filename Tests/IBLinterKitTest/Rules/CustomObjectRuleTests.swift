//
//  CustomObjectRuleTests.swift
//  IBLinterKitTest
//
//  Created by Blazej Sleboda on 05/07/2022.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class CustomObjectRuleTests: XCTestCase {

    private let fixture = Fixture()
    private let defaultEnabledRules = Rules.defaultRules.map { $0.identifier }
    private let projectMockPath = "Resources/Rules/CustomObjectRule"
    private var rule: Rules.CustomObjectRule!

    override func setUp() {
        super.setUp()
        rule = Rules.CustomObjectRule(context: .mock(from: .init()))
    }

    func testStoryboardWithoutCustomObjects() throws {
        let url = fixture.path("\(projectMockPath)/WithoutCustomObjects.storyboard")
        let violations = try rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertTrue(violations.isEmpty)
    }

    func testStoryboardWithTwoViewControllersInEachOfThemOneCustomObject() throws {
        let url = fixture.path("\(projectMockPath)/WithCustomObjects.storyboard")
        let violations = try rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }
}
