//
//  Violation.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBDecodable
import Foundation

public struct Violation {
    let interfaceBuilderFile: InterfaceBuilderFile
    let message: String
    let level: Level

    enum Level: String, Comparable {
        case warning
        case error

        static func < (lhs: Violation.Level, rhs: Violation.Level) -> Bool {
            return lhs == .warning && rhs == .error
        }
    }
}
