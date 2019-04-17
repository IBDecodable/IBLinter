//
//  Validator.swift
//  IBLinterKit
//
//  Created by Yuta Saito on 2019/03/31.
//

import Foundation
import IBDecodable

public class Validator {

    let externalRules: [Rule.Type]

    public init(externalRules: [Rule.Type] = []) {
        self.externalRules = externalRules
    }

    public func validate(workDirectory: URL, config: Config) -> [Violation] {
        let context = Context(config: config, workDirectory: workDirectory, externalRules: externalRules)
        let rules = Rules.rules(context)
        return validateXib(workDirectory: workDirectory, rules: rules, config: config)
            + validateStoryboard(workDirectory: workDirectory, rules: rules, config: config)
    }

    public func validateStoryboard(workDirectory: URL, rules: [Rule], config: Config) -> [Violation] {
        let lintablePaths = config.lintablePaths(workDirectory: workDirectory, fileExtension: "storyboard")
        return rules.flatMap { rule in
            return lintablePaths.flatMap { path -> [Violation] in
                do {
                    let file = try StoryboardFile.init(path: path.relativePath)
                    return rule.validate(storyboard: file)
                } catch let error as InterfaceBuilderParser.Error {
                    return [error.asViolation(filePath: path)]
                } catch let error {
                    fatalError("parse error \(path.relativePath): \(error)")
                }
            }
        }
    }

    public func validateXib(workDirectory: URL, rules: [Rule], config: Config) -> [Violation] {
        let lintablePaths = config.lintablePaths(workDirectory: workDirectory, fileExtension: "xib")
        return rules.flatMap { rule in
            return lintablePaths.flatMap { path -> [Violation] in
                do {
                    let file = try XibFile.init(path: path.relativePath)
                    return rule.validate(xib: file)
                } catch let error as InterfaceBuilderParser.Error {
                    return [error.asViolation(filePath: path)]
                } catch let error {
                    fatalError("parse error \(path.relativePath): \(error)")
                }
            }
        }
    }
}

extension InterfaceBuilderParser.Error {
    func asViolation(filePath path: URL) -> Violation {
        switch self {
        case .invalidFormatFile:
            return Violation(
                pathString: path.relativePath,
                message: "invalid format and skipped",
                level: .warning
            )
        case .legacyFormat:
            return Violation(
                pathString: path.relativePath,
                message: "\(path.relativePath) is legacy format. Please open with latest Xcode to migrate.",
                level: .warning
            )
        case .parsingError(let error):
            return Violation(
                pathString: path.relativePath,
                message: "Parse error \(error)",
                level: .warning
            )
        case .macFormat:
            return Violation(
                pathString: path.relativePath,
                message: "Parse error. You are using Cocoa. Please refer a format.",
                level: .warning
            )
        }
    }
}
