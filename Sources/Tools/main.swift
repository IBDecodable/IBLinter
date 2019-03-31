import Commandant

let registry = CommandRegistry<CommandantError<()>>()
let helpCommand = HelpCommand(registry: registry)
registry.register(helpCommand)
registry.register(DumpRuleDocument())
registry.main(defaultVerb: helpCommand.verb) { (error) in
    print(error)
}
