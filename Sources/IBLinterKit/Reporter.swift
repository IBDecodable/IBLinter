//
//  Reporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import Foundation

protocol Reporter {
    func report(violation: Violation) -> String
}

struct XcodeReporter: Reporter {

    private func locationDescription(_ location: Violation.Location) -> String {
        return "\(location.line):\(location.column): "
    }

    func report(violation: Violation) -> String {
        return [
            "\(violation.file.pathString):",
            "\(violation.location.map { locationDescription($0) } ?? ":: " )",
            "\(violation.level.rawValue): ",
            violation.message,
            ].joined()

    }
}
