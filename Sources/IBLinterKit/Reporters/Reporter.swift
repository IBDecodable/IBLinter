//
//  Reporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

protocol Reporter {
    static var identifier: String { get }

    func report(violations: [Violation])
}

struct Reporters {

    static func reporter(from config: Config) -> Reporter {
        switch config.reporter {
        case XcodeReporter.identifier:
            return XcodeReporter()
        case JSONReporter.identifier:
            return JSONReporter()
        default:
            fatalError("no reporter with identifier '\(config.reporter) available'")
        }
    }
}
