//
//  ValidateCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Result
import Foundation
import IBLinterCore
import Commandant

struct ValidateCommand: CommandProtocol {
    typealias Options = ValidateOptions
    typealias ClientError = Options.ClientError

    let verb: String = "lint"
    var function: String = "Print lint warnings and errors (default command)"

    func run(_ options: ValidateCommand.Options) -> Result<(), ValidateCommand.ClientError> {
        let workDirectory = options.path ?? FileManager.default.currentDirectoryPath
        guard FileManager.default.isDirectory(workDirectory) else { fatalError("\(workDirectory) is not directory.") }
        let config = (try? Config.load(from: workDirectory)) ?? Config.default
        let violations = validate(workDirectory: workDirectory, config: config)

        let reporter = XcodeReporter.init()
        violations.map(reporter.report).forEach { print($0) }

        let numberOfSeriousViolations = violations.filter { $0.level == .error }.count
        if numberOfSeriousViolations > 0 {
            exit(2)
        } else {
            return .success(())
        }
    }

    private func validate(workDirectory: String, config: Config) -> [Violation] {
        return validateXib(workDirectory: workDirectory, config: config) + validateStoryboard(workDirectory: workDirectory, config: config)
    }

    public func validateStoryboard(workDirectory: String, config: Config) -> [Violation] {
        let paths = glob(pattern: "\(workDirectory)/**/*.storyboard")
        let excluded = config.excluded.flatMap { glob(pattern: "\($0)/**/*.storyboard") }
        let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
        let storyboards = lintablePaths.map { StoryboardFile.init(path: $0.relativePath) }
        let violations = Rules.rules(config).flatMap { rule in storyboards.flatMap { rule.validate(storyboard: $0) } }
        return violations
    }

    public func validateXib(workDirectory: String, config: Config) -> [Violation] {
        let paths = glob(pattern: "\(workDirectory)/**/*.xib")
        let excluded = config.excluded.flatMap { glob(pattern: "\($0)/**/*.xib") }
        let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
        let xibs = lintablePaths.map { XibFile.init(path: $0.relativePath) }
        let violations = Rules.rules(config).flatMap { rule in xibs.flatMap { rule.validate(xib: $0) } }
        return violations
    }
}

struct ValidateOptions: OptionsProtocol {
    typealias ClientError = CommandantError<()>

    let path: String?

    static func evaluate(_ m: CommandMode) -> Result<ValidateCommand.Options, CommandantError<ValidateOptions.ClientError>> {
        return ValidateOptions.init
            <*> m <| Option.init(key: "path", defaultValue: nil, usage: "validate project root directory")
    }
}
