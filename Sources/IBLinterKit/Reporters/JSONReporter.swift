//
//  JSONReporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/04/19.
//

import Foundation

struct JSONReporter: Reporter {

    static let identifier: String = "json"

    func report(violations: [Violation]) {
        let dictionary = violations.map(toJSON)
        let json = try! JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        if let jsonString = String(data: json, encoding: .utf8) {
            print(jsonString)
        }
    }

    func toJSON(violation: Violation) -> [String: Any] {
        return [
            "file": violation.interfaceBuilderFile.pathString,
            "level": violation.level.rawValue,
            "message": violation.message
        ]
    }
}

