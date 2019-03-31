//
//  XcodeReporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/04/19.
//

struct XcodeReporter: Reporter {

    static let identifier = "xcode"

    static func generateReport(violations: [Violation]) -> String {
        return violations.map(report).joined(separator: "\n")
    }

    static func report(violation: Violation) -> String {
        return [
            "\(violation.pathString):",
            "0:0: ",
            "\(violation.level.rawValue): ",
            violation.message
            ].joined()

    }
}
