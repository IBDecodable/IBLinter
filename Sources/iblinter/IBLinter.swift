//
//  IBLinter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBLinterKit
import Commandant

public struct IBLinter {

    public init() {}

    public func run() {
        let registry = CommandRegistry<CommandantError<()>>()
        registry.register(ValidateCommand())
        registry.register(HelpCommand(registry: registry))
        registry.register(VersionCommand())

        registry.main(defaultVerb: ValidateCommand().verb) { (error) in
            print(String.init(describing: error))
        }
    }
}
