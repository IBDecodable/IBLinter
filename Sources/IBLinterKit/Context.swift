//
//  Context.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/15.
//

import Foundation

public struct Context {
    let config: Config
    let workDirectory: URL
    let externalRules: [Rule.Type]

    public init(config: Config, workDirectory: URL, externalRules: [Rule.Type]) {
        self.config = config
        self.workDirectory = workDirectory
        self.externalRules = externalRules
    }
}
