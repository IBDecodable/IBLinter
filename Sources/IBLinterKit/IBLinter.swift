//
//  IBLinter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBDecodable
import Commandant

public struct IBLinter {

    public init() {}

    public func run() {
        let registry = CommandRegistry<CommandantError<()>>()
        registry.register(ValidateCommand.init())
        registry.register(HelpCommand.init(registry: registry))
        registry.register(VersionCommand.init())

        registry.main(defaultVerb: ValidateCommand.init().verb) { (error) in
            print(String.init(describing: error))
        }
    }

}

extension IBLinter {

    public func addRule<R: Rule>(_ ruleType: R.Type) {
        Rules.allRules.append(ruleType)
    }
}
