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

    public func run(externalRules: [Rule.Type] = []) {
        let registry = CommandRegistry<CommandantError<()>>()
        registry.register(ValidateCommand(externalRules: externalRules))
        registry.register(EditCommand())
        registry.register(HelpCommand(registry: registry))
        registry.register(VersionCommand())

        registry.main(defaultVerb: ValidateCommand(externalRules: externalRules).verb) { (error) in
            print(String.init(describing: error))
        }
    }

}
