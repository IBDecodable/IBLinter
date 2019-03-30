//
//  RelativeToMarginRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class RelativeToMarginRuleTests: XCTestCase {

    let fixture = Fixture()

    func testRelativeToMargin() {
        let url = fixture.path("Resources/Rules/RelativeToMarginRule/ConstraintTest.storyboard")
        let rule = Rules.RelativeToMarginRule(context: .mock(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 4)
    }
}
