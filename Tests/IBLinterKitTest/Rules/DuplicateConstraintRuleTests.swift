//
//  DuplicateConstraintRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class DuplicateConstraintRuleTests: XCTestCase {

    let fixture = Fixture()

    func testDuplicateConstraint() {
        let url = fixture.path("Resources/Rules/DuplicateConstraintRule/DuplicateConstraint.xib")
        let rule = Rules.DuplicateConstraintRule(context: .mock(from: .default))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }
}
