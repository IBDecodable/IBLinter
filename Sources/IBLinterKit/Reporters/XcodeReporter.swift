//
//  XcodeReporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/04/19.
//

struct XcodeReporter: Reporter {

    static let identifier: String = "xcode"

    static func generateReport(violations: [Violation]) -> String {
        return violations.map(report).joined(separator: "\n")
    }

    static func report(violation: Violation) -> String {
        return [
            "\(violation.pathString):",
            ":: ",
            "\(violation.level.rawValue): ",
            violation.message
            ].joined()

    }
}
