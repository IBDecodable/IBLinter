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
        let (xibs, storyboards) = lintablePaths(workDirectory: workDirectory, config: config)
        return validateXib(files: xibs, rules: rules, config: config)
            + validateStoryboard(files: storyboards, rules: rules, config: config)
    }

    public func validateStoryboard(files: Set<URL>, rules: [Rule], config: Config) -> [Violation] {
        return rules.flatMap { rule in
            return files.flatMap { path -> [Violation] in
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

    public func validateXib(files: Set<URL>, rules: [Rule], config: Config) -> [Violation] {
        return rules.flatMap { rule in
            return files.flatMap { path -> [Violation] in
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

    private struct InterfaceBuilderFiles {
        var xibPaths: Set<URL> = []
        var storyboardPaths: Set<URL> = []
    }

    private final class LintableFileMatcher {
        let fileManager: FileManager
        let globber: Glob
        init(fileManager: FileManager = .default) {
            self.fileManager = fileManager
            self.globber = Glob(fileManager: fileManager)
        }

        func interfaceBuilderFiles(withPatterns patterns: [URL]) -> InterfaceBuilderFiles {
            return patterns.flatMap { globber.expandRecursiveStars(pattern: $0.path) }
                .reduce(into: InterfaceBuilderFiles()) { result, path in
                    let files = self.interfaceBuilderFiles(atPath: URL(fileURLWithPath: path))
                    result.xibPaths.formUnion(files.xibPaths)
                    result.storyboardPaths.formUnion(files.storyboardPaths)
            }
        }

        func interfaceBuilderFiles(atPath path: URL) -> InterfaceBuilderFiles {
            var xibs: Set<URL> = []
            var storyboards: Set<URL> = []
            guard let enumerator = fileManager.enumerator(at: path, includingPropertiesForKeys: [.isRegularFileKey]) else {
                return InterfaceBuilderFiles(xibPaths: xibs, storyboardPaths: storyboards)
            }

            for element in enumerator {
                guard let absolute = element as? URL else { continue }
                switch absolute.pathExtension {
                case "xib": xibs.insert(absolute)
                case "storyboard": storyboards.insert(absolute)
                default: continue
                }
            }
            return InterfaceBuilderFiles(xibPaths: xibs, storyboardPaths: storyboards)
        }
    }

    public func lintablePaths(workDirectory: URL, config: Config, fileManager: FileManager = .default) -> (xib: Set<URL>, storyboard: Set<URL>) {
        let matcher = LintableFileMatcher(fileManager: fileManager)
        let files: InterfaceBuilderFiles
        if config.included.isEmpty {
            files = matcher.interfaceBuilderFiles(atPath: workDirectory)
        } else {
            files = matcher.interfaceBuilderFiles(
                withPatterns: config.included.map { workDirectory.appendingPathComponent($0) }
            )
        }

        let excluded = matcher.interfaceBuilderFiles(
            withPatterns: config.excluded.map { workDirectory.appendingPathComponent($0) }
        )
        let xibLintablePaths = files.xibPaths.subtracting(excluded.xibPaths)
        let storyboardLintablePaths = files.storyboardPaths.subtracting(excluded.storyboardPaths)
        return (xibLintablePaths, storyboardLintablePaths)
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
