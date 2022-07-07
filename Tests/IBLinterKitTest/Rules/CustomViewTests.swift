//
//  CustomViewTests.swift
//  IBLinterKitTest
//
//  Created by Blazej Sleboda on 07/07/2022.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class CustomViewTests: XCTestCase {

    private let fixture = Fixture()
    private let projectMockPath = "Resources/Rules/CustomViewRule"
    private var rule: Rules.CustomViewRule!

    override func setUp() {
        super.setUp()
        rule = Rules.CustomViewRule(context: .mock(from: .init()))
    }

    func testStoryboardWithoutCustomObjects() throws {
        let url = fixture.path("\(projectMockPath)/WithoutCustomViews.storyboard")
        let violations = try rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertTrue(violations.isEmpty)
    }

    func testStoryboardWithTwoViewControllersInEachOfThemOneCustomObject() throws {
        let url = fixture.path("\(projectMockPath)/WithCustomViews.storyboard")
        let violations = try rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 3)
    }
}
