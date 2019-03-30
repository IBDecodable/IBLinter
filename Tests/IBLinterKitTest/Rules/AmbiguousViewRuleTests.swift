//
//  AmbiguousViewRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class AmbiguousViewRuleTests: XCTestCase {

    let fixture = Fixture()

    func testAmbiguous() {
        let url = fixture.path("Resources/Rules/AmbiguousViewRule/AmbiguousConstraint.storyboard")
        let rule = Rules.AmbiguousViewRule(context: .mock(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }
}
