//
//  Reporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

public protocol Reporter {
    static var identifier: String { get }

    static func generateReport(violations: [Violation]) -> String
}

public struct Reporters {

    public static func reporter(from reporter: String) -> Reporter.Type {
        switch reporter {
        case XcodeReporter.identifier:
            return XcodeReporter.self
        case JSONReporter.identifier:
            return JSONReporter.self
        case EmojiReporter.identifier:
            return EmojiReporter.self
        default:
            fatalError("no reporter with identifier '\(reporter) available'")
        }
    }
}
