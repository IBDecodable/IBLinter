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

    let currentVersion: String = "0.4.4"

    func run(_ options: NoOptions<CommandantError<()>>) -> Result<(), CommandantError<()>> {
        print(currentVersion)
        return .success(())
    }
}
