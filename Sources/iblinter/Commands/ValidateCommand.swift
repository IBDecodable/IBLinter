//
//  ValidateCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Result
import Foundation
import IBDecodable
import IBLinterKit
import Commandant
import PathKit

struct ValidateCommand: CommandProtocol {
    typealias Options = ValidateOptions
    typealias ClientError = Options.ClientError

    let verb: String = "lint"
    var function: String = "Print lint warnings and errors (default command)"

    let externalRules: [Rule.Type]

    init(externalRules: [Rule.Type] = []) {
        self.externalRules = externalRules
    }

    func run(_ options: ValidateCommand.Options) -> Result<(), ValidateCommand.ClientError> {

        let iblinterFilePath: Path? = {
            if let iblinterFilePathString = options.iblinterFilePath {
                let iblinterFilePath = Path(iblinterFilePathString)
                guard iblinterFilePath.exists else {
                    fatalError("\(iblinterFilePath) not found")
                }
                return iblinterFilePath
            } else {
                let defaultFile = Path("./IBLinterfile.swift")
                guard defaultFile.exists else { return nil }
                return defaultFile
            }
        }()
        if let iblinterFilePath = iblinterFilePath {
            return IBLinterRunner(ibLinterfile: iblinterFilePath).run()
        }

        return runInternal(options)
    }

    func runInternal(_ options: ValidateCommand.Options) -> Result<(), ValidateCommand.ClientError> {
        let workDirectoryString = options.path ?? FileManager.default.currentDirectoryPath
        guard let workDirectory = URL(string: workDirectoryString),
            FileManager.default.isDirectory(workDirectory.path) else {
                fatalError("\(workDirectoryString) is not directory.")
        }
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

    private func validate(workDirectory: URL, config: Config) -> [Violation] {
        let context = Context(config: config, workDirectory: workDirectory, externalRules: externalRules)
        let rules = Rules.rules(context)
        return validateXib(workDirectory: workDirectory, rules: rules, config: config) + validateStoryboard(workDirectory: workDirectory, rules: rules, config: config)
    }

    public func validateStoryboard(workDirectory: URL, rules: [Rule], config: Config) -> [Violation] {
        let lintablePaths = config.lintablePaths(workDirectory: workDirectory, fileExtension: "storyboard")
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
                case .parsingError(let error):
                    print("\($0.relativePath):\(error.line):\(error.column): error: Parse error")
                    return nil
                }
            } catch let error {
                fatalError("parse error \($0.relativePath): \(error)")
            }
        }
        let violations = rules.flatMap { rule in storyboards.flatMap { rule.validate(storyboard: $0) } }
        return violations
    }

    public func validateXib(workDirectory: URL, rules: [Rule], config: Config) -> [Violation] {
        let lintablePaths = config.lintablePaths(workDirectory: workDirectory, fileExtension: "xib")
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
                case .parsingError(let error):
                    print("\($0.relativePath):\(error.line):\(error.column): error: Parse error")
                    return nil
                }
            } catch let error {
                fatalError("parse error \($0.relativePath): \(error)")
            }
        }
        let violations = rules.flatMap { rule in xibs.flatMap { rule.validate(xib: $0) } }
        return violations
    }
}

struct ValidateOptions: OptionsProtocol {
    typealias ClientError = CommandantError<()>

    let path: String?
    let reporter: String?
    let iblinterFilePath: String?

    static func create(_ path: String?) -> (_ reporter: String?) -> (_ script: String?) -> ValidateOptions {
        return { reporter in
            return { script in
                self.init(path: path, reporter: reporter, iblinterFilePath: script)
            }
        }
    }

    static func evaluate(_ mode: CommandMode) -> Result<ValidateCommand.Options, CommandantError<ValidateOptions.ClientError>> {
        return create
            <*> mode <| Option(key: "path", defaultValue: nil, usage: "validate project root directory")
            <*> mode <| Option(key: "reporter", defaultValue: nil, usage: "the reporter used to log errors and warnings")
            <*> mode <| Option(key: "script", defaultValue: nil, usage: "custom IBLinterfile.swift")
    }
}
