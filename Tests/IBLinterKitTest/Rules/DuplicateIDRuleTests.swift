//
//  DuplicateConstraintRuleTests.swift
//  IBLinterKitTest
//
//  Created by Eric Marchand on 2019/10/29.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class DuplicateIDRuleTests: XCTestCase {

    let fixture = Fixture()

    func testDuplicateId() {
        let url = fixture.path("Resources/Rules/DuplicateIDRule/DuplicateID.xib")
        let rule = Rules.DuplicateIDRule(context: .mock(from: .default))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 2)
        let expectedMessages = ["iN0-l3-epB", "aEU-56-OK8"].map { "duplicate element id \($0)"}
        XCTAssertEqual(violations.map { $0.message }, expectedMessages)
    }
}
