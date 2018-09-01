//
//  Context.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/15.
//

public struct Context {
    public let config: Config
    public let workDirectory: String
    public let externalRules: [Rule.Type]

    public init(config: Config, workDirectory: String, externalRules: [Rule.Type]) {
        self.config = config
        self.workDirectory = workDirectory
        self.externalRules = externalRules
    }
}
