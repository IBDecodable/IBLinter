//
//  ValidateCommand.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Foundation
import IBDecodable
import IBLinterKit
import ArgumentParser

struct ValidateCommand: ParsableCommand {
    static let configuration = CommandConfiguration(commandName: "lint", abstract: "Print lint warnings and errors")

    @Option(name: .long, help: "validate project root directory", completion: .directory)
    var path: String?
    @Option(name: .long, help: "the reporter used to log errors and warnings")
    var reporter: String?
    @Option(name: .long, help: "custom IBLinterfile.swift", completion: .file(extensions: ["swift"]))
    var iblinterFilePath: String?
    @Option(name: .long, help: "the path to IBLint's configuration file", completion: .file())
    var configurationFile: String?
    @Argument(help: "included files/paths to lint. This is ignored if you specified included paths in your yml configuration file.",
              completion: .file())
    var included: [String] = []

    func run() throws {
        let workDirectoryString = path ?? FileManager.default.currentDirectoryPath
        let workDirectory = URL(fileURLWithPath: workDirectoryString)
        guard FileManager.default.isDirectory(workDirectory.path) else {
            fatalError("\(workDirectoryString) is not directory.")
        }

        var config = (try? Config(url: deriveConfigurationFile())) ?? Config.default
        if config.disableWhileBuildingForIB &&
            ProcessInfo.processInfo.compiledForInterfaceBuilder {
            return
        }
        if config.included.isEmpty {
            config.included = included
        }
        let validator = Validator()
        let violations = validator.validate(workDirectory: workDirectory, config: config)

        let reporter = Reporters.reporter(from: self.reporter ?? config.reporter)
        let report = reporter.generateReport(violations: violations)
        print(report)

        let numberOfSeriousViolations = violations.filter { $0.level == .error }.count
        if numberOfSeriousViolations > 0 {
            throw ValidationError("")
        }
    }

    func deriveConfigurationFile() -> URL {
        if let configurationFile = configurationFile {
            let configurationURL = URL(fileURLWithPath: configurationFile)
            return configurationURL
        } else {
            let workDirectoryString = path ?? FileManager.default.currentDirectoryPath
            let workDirectory = URL(fileURLWithPath: workDirectoryString)
            return workDirectory.appendingPathComponent(Config.fileName)
        }
    }
}

extension ProcessInfo {
    var compiledForInterfaceBuilder: Bool {
        return environment["COMPILED_FOR_INTERFACE_BUILDER"] != nil
    }
}
