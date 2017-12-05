//
//  Violation.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBLinterCore
import Foundation

public struct Violation {
    let interfaceBuilderFile: InterfaceBuilderFile
    let message: String
    let level: Level

    enum Level: String {
        case warning
        case error
    }
}
