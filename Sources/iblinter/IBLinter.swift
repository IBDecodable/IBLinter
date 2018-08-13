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
        registry.register(EditCommand())
        registry.register(HelpCommand(registry: registry))
        registry.register(VersionCommand())

        registry.main(defaultVerb: ValidateCommand().verb) { (error) in
            print(String.init(describing: error))
        }
    }

    public func lint(externalRules: [Rule.Type] = []) {
        guard let options = ValidateCommand.Options
            .evaluate(.arguments(ArgumentParser(CommandLine.arguments))).value else { return }
        switch ValidateCommand(externalRules: externalRules).runInternal(options) {
        case .success:
            return
        case .failure(let error):
            print(error)
            return
        }
    }
}
