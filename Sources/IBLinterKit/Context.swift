//
//  Context.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/15.
//

import Foundation

public struct Context {
    public let config: Config
    public let workDirectory: String
    public let configPath: URL?
    public let externalRules: [Rule.Type]

    public init(config: Config, workDirectory: String, configPath: URL?, externalRules: [Rule.Type]) {
        self.config = config
        self.workDirectory = workDirectory
        self.configPath = configPath
        self.externalRules = externalRules
    }
}
