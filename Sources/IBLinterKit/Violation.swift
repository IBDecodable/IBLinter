//
//  Violation.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBLinterCore
import Foundation

public struct Violation {
    let file: FileProtocol
    let message: String
    let level: Level
    let location: Location?

    init(file: FileProtocol, message: String, level: Level, location: Location? = nil) {
        self.file = file
        self.message = message
        self.level = level
        self.location = location
    }

    struct Location {
        let line: Int
        let column: Int
    }

    enum Level: String {
        case warning
        case error
    }
}
