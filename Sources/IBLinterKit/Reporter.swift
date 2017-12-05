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
    func report(violation: Violation) -> String {
        return [
            "\(violation.interfaceBuilderFile.pathString):",
            ":: ",
            "\(violation.level.rawValue): ",
            violation.message,
            ].joined()

    }
}
