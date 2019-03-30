//
//  CustomClassNameRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class CustomClassNameRuleTests: XCTestCase {

    let fixture = Fixture()

    func testCustomClassName() {
        let url = fixture.path("Resources/Rules/CustomClassNameRule/ViewControllerTest.storyboard")
        let rule = Rules.CustomClassNameRule(context: .mock(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }
}
