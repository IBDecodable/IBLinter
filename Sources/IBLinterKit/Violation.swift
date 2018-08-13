//
//  Violation.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBDecodable
import Foundation

public struct Violation {
    public let pathString: String
    public let message: String
    public let level: Level

    public enum Level: String, Comparable {
        case warning
        case error

        public static func < (lhs: Violation.Level, rhs: Violation.Level) -> Bool {
            return lhs == .warning && rhs == .error
        }
    }
}
