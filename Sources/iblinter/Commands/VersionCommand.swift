//
//  VersionCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/17.
//

import Result
import Commandant

struct VersionCommand: CommandProtocol {
    typealias Options = NoOptions<CommandantError<IBLinterError>>
    let verb = "version"
    let function = "Display the current version of IBLinter"

    let currentVersion: String = "0.4.3"

    func run(_ options: Options) -> Result<(), CommandantError<IBLinterError>> {
        print(currentVersion)
        return .success(())
    }
}
