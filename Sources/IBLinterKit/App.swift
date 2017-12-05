//
//  App.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBLinterCore
import Commandant

public struct App {

    public init() {}

    public func main() {
        let registry = CommandRegistry<CommandantError<()>>()
        registry.register(ValidateCommand.init())
        registry.register(HelpCommand.init(registry: registry))

        registry.main(defaultVerb: ValidateCommand.init().verb) { (error) in
            print(String.init(describing: error))
        }
    }

}
