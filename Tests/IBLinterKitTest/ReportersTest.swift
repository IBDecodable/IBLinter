//
//  ReportersTest.swift
//  IBLinterKitTest
//
//  Created by SaitoYuta on 2018/04/19.
//

@testable import IBLinterKit
import IBLinterCore
import XCTest

class ReportersTest: XCTestCase {

    func testJSONReporter() {
        let reporter = JSONReporter.self

        let path = "Tests/IBLinterKitTest/Resources/ViewTest.xib"
        let violation = Violation(interfaceBuilderFile: try! XibFile(path: path),
                                  message: "Violation Reason 1.", level: .error)
        let json = reporter.toJSON(violation: violation)
        let expectedJSON: [String: Any] = [
            "message": "Violation Reason 1.",
            "file": path,
            "level": "error"
        ]
        XCTAssertEqual(json, expectedJSON)
    }
}

func XCTAssertEqual(_ l: [String: Any], _ r: [String: Any]) {
    l.keys.forEach { key in
        if let left = l[key] as? String, let right = r[key] as? String {
            XCTAssertEqual(left, right)
        } else if let left = l[key] as? Bool, let right = r[key] as? Bool {
            XCTAssertEqual(left, right)
        } else {
            XCTFail()
        }
    }
}
