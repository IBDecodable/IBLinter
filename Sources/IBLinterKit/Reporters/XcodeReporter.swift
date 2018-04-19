//
//  XcodeReporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/04/19.
//

struct XcodeReporter: Reporter {

    static let identifier: String = "xcode"

    func report(violations: [Violation]) {
        violations.map(report).forEach { print($0) }
    }

    func report(violation: Violation) -> String {
        return [
            "\(violation.interfaceBuilderFile.pathString):",
            ":: ",
            "\(violation.level.rawValue): ",
            violation.message,
            ].joined()

    }
}
