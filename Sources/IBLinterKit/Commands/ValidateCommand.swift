//
//  ValidateCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Result
import Foundation
import IBDecodable
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

    private func validate(workDirectory: String, config: Config) -> [Violation] {
        return validateXib(workDirectory: workDirectory, config: config) + validateStoryboard(workDirectory: workDirectory, config: config)
    }

    public func validateStoryboard(workDirectory: String, config: Config) -> [Violation] {
        let paths = glob(pattern: "\(workDirectory)/**/*.storyboard")
        let excluded = config.excluded.flatMap { glob(pattern: "\($0)/**/*.storyboard") }
        let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
        let storyboards: [StoryboardFile] = lintablePaths.compactMap {
            do {
                return try StoryboardFile.init(path: $0.relativePath)
            } catch let error as InterfaceBuilderParser.Error {
                switch error {
                case .invalidFormatFile:
                    print("\($0.relativePath) is invalid format and skipped")
                    return nil
                case .legacyFormat:
                    print("\($0.relativePath) is legacy format. Please open with latest Xcode to migrate.")
                    return nil
                case .macFormat:
                    print("\($0.relativePath) is mac format and skipped.")
                    return nil
                }
            } catch let error {
                fatalError("parse error \($0.relativePath): \(error)")
            }
        }
        let context = Context(config: config, workDirectory: workDirectory)
        let violations = Rules.rules(context).flatMap { rule in storyboards.flatMap { rule.validate(storyboard: $0) } }
        return violations
    }

    public func validateXib(workDirectory: String, config: Config) -> [Violation] {
        let paths = glob(pattern: "\(workDirectory)/**/*.xib")
        let excluded = config.excluded.flatMap { glob(pattern: "\($0)/**/*.xib") }
        let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
        let xibs: [XibFile] = lintablePaths.compactMap {
            do {
                return try XibFile.init(path: $0.relativePath)
            } catch let error as InterfaceBuilderParser.Error {
                switch error {
                case .invalidFormatFile:
                    print("\($0.relativePath) is invalid format and skipped")
                    return nil
                case .legacyFormat:
                    print("\($0.relativePath) is legacy format. Please open with latest Xcode to migrate.")
                    return nil
                case .macFormat:
                    print("\($0.relativePath) is mac format and skipped.")
                    return nil
                }
            } catch let error {
                fatalError("parse error \($0.relativePath): \(error)")
            }
        }
        let context = Context(config: config, workDirectory: workDirectory)
        let violations = Rules.rules(context).flatMap { rule in xibs.flatMap { rule.validate(xib: $0) } }
        return violations
    }
}

struct ValidateOptions: OptionsProtocol {
    typealias ClientError = CommandantError<()>

    let path: String?
    let reporter: String?

    static func create(_ path: String?) -> (_ reporter: String?) -> ValidateOptions {
        return { reporter in
            self.init(path: path, reporter: reporter)
        }
    }

    static func evaluate(_ mode: CommandMode) -> Result<ValidateCommand.Options, CommandantError<ValidateOptions.ClientError>> {
        return create
            <*> mode <| Option(key: "path", defaultValue: nil, usage: "validate project root directory")
            <*> mode <| Option(key: "reporter", defaultValue: nil, usage: "the reporter used to log errors and warnings")
    }
}
