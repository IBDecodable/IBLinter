//
//  IBLinter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import ArgumentParser
import IBLinterKit

public struct IBLinter: ParsableCommand {
    public init() {}
    public static let configuration = CommandConfiguration(commandName: "iblinter", version: Version.current.value,
                                                           subcommands: [ValidateCommand.self], defaultSubcommand: ValidateCommand.self)
}
