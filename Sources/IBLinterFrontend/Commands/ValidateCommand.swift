//
//  ValidateCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Foundation
import IBDecodable
import IBLinterKit
import Commandant

struct ValidateCommand: CommandProtocol {
    typealias Options = ValidateOptions
    typealias ClientError = Options.ClientError

    let verb: String = "lint"
    var function: String = "Print lint warnings and errors (default command)"

    func run(_ options: ValidateCommand.Options) -> Result<(), ValidateCommand.ClientError> {
        let workDirectoryString = options.path ?? FileManager.default.currentDirectoryPath
        let workDirectory = URL(fileURLWithPath: workDirectoryString)
        guard FileManager.default.isDirectory(workDirectory.path) else {
            fatalError("\(workDirectoryString) is not directory.")
        }

        let config = Config(options: options) ?? Config.default
        if config.disableWhileBuildingForIB &&
            ProcessInfo.processInfo.compiledForInterfaceBuilder {
            return .success(())
        }
        let validator = Validator()
        let violations = validator.validate(workDirectory: workDirectory, config: config)

        let reporter = Reporters.reporter(from: options.reporter ?? config.reporter)
        let report = reporter.generateReport(violations: violations)
        print(report)

        let numberOfSeriousViolations = violations.filter { $0.level == .error }.count
        if numberOfSeriousViolations > 0 {
            exit(2)
        } else {
            return .success(())
        }
    }
}

struct ValidateOptions: OptionsProtocol {
    typealias ClientError = CommandantError<()>

    let path: String?
    let reporter: String?
    let iblinterFilePath: String?
    let configurationFile: String?

    static func create(_ path: String?) -> (_ reporter: String?) -> (_ script: String?) -> (_ config: String?) -> ValidateOptions {
        return { reporter in
            return { script in
                return { config in
                    self.init(path: path, reporter: reporter, iblinterFilePath: script, configurationFile: config)
                }
            }
        }
    }

    static func evaluate(_ mode: CommandMode) -> Result<ValidateCommand.Options, CommandantError<ValidateOptions.ClientError>> {
        return create
            <*> mode <| Option(key: "path", defaultValue: nil, usage: "validate project root directory")
            <*> mode <| Option(key: "reporter", defaultValue: nil, usage: "the reporter used to log errors and warnings")
            <*> mode <| Option(key: "script", defaultValue: nil, usage: "custom IBLinterfile.swift")
            <*> mode <| Option(key: "config", defaultValue: nil, usage: "the path to IBLint's configuration file")
    }
}

extension ProcessInfo {
    var compiledForInterfaceBuilder: Bool {
        return environment["COMPILED_FOR_INTERFACE_BUILDER"] != nil
    }
}

extension Config {
    init?(options: ValidateOptions) {
        if let configurationFile = options.configurationFile {
            let configurationURL = URL(fileURLWithPath: configurationFile)
            try? self.init(url: configurationURL)
        } else {
            let workDirectoryString = options.path ?? FileManager.default.currentDirectoryPath
            let workDirectory = URL(fileURLWithPath: workDirectoryString)
            try? self.init(directoryURL: workDirectory)
        }
    }
}
