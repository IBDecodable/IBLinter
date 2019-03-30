//
//  VersionCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/17.
//

import Result
import Commandant

struct VersionCommand: CommandProtocol {
    let verb = "version"
    let function = "Display the current version of IBLinter"

    func run(_ options: NoOptions<CommandantError<()>>) -> Result<(), CommandantError<()>> {
        print(Version.current.value)
        return .success(())
    }
}
