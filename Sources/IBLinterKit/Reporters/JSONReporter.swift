//
//  JSONReporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/04/19.
//

import Foundation

struct JSONReporter: Reporter {

    static let identifier: String = "json"

    static func generateReport(violations: [Violation]) -> String {
        let dictionary = violations.map(toJSON)
        if let json = try? JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted),
            let jsonString = String(data: json, encoding: .utf8) {
            return jsonString
        }
        return ""
    }

    static func toJSON(violation: Violation) -> [String: Any] {
        return [
            "file": violation.interfaceBuilderFile.pathString,
            "level": violation.level.rawValue,
            "message": violation.message
        ]
    }
}
