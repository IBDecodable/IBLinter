//
//  DuplicateConstraintRuleTests.swift
//  IBLinterKitTest
//
//  Created by Eric Marchand on 2019/10/29.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class DuplicateIdRuleTests: XCTestCase {

    let fixture = Fixture()

    func testDuplicateId() {
        let url = fixture.path("Resources/Rules/DuplicateIdRule/DuplicateId.xib")
        let rule = Rules.DuplicateIdRule(context: .mock(from: .default))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }
}
