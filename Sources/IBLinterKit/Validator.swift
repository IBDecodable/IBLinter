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
        let cache: LintCache = {
            guard !config.ignoreCache else { return LintEmptyCache() }
            do {
                return try LintDiskCache.load(with: FileManager.default, config: config)
            } catch {
                if let new = try? LintDiskCache.new(with: FileManager.default, config: config) {
                    return new
                } else {
                    return LintEmptyCache()
                }
            }
        }()
        defer {
            do { try cache.save() } catch { fputs(String(describing: error), stderr) }
        }
        let (xibs, storyboards) = lintablePaths(workDirectory: workDirectory, config: config)
        return
            doValidate(files: storyboards, rules: rules, config: config, cache: cache) { rule, file in
                let file = try StoryboardFile.init(path: file.relativePath)
                return rule.validate(storyboard: file)
            }
            +
            doValidate(files: xibs, rules: rules, config: config, cache: cache) { rule, file in
                let file = try XibFile.init(path: file.relativePath)
                return rule.validate(xib: file)
            }
    }

    public func doValidate(
        files: Set<URL>, rules: [Rule], config: Config, cache: LintCache,
        validate: (Rule, URL) throws -> [Violation]) -> [Violation] {
        var violations: [Violation] = []

        for path in files {
            if let cachedViolations = cache.violations(for: path) {
                violations.append(contentsOf: cachedViolations)
                continue
            }
            let fileViolations = rules.flatMap { rule -> [Violation] in
                do {
                    return try validate(rule, path)
                } catch let error as InterfaceBuilderParser.Error {
                    return [error.asViolation(filePath: path)]
                } catch let error {
                    fatalError("parse error \(path.relativePath): \(error)")
                }
            }
            cache.insertCache(for: path, violations: fileViolations)
            violations.append(contentsOf: fileViolations)
        }
        return violations
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
                    let url = URL(fileURLWithPath: path)
                    guard url.hasDirectoryPath else {
                        switch url.pathExtension {
                        case "xib": result.xibPaths.insert(url)
                        case "storyboard": result.storyboardPaths.insert(url)
                        default:
                            break
                        }
                        return
                    }

                    let files = self.interfaceBuilderFiles(atPath: URL(fileURLWithPath: path))
                    result.xibPaths.formUnion(files.xibPaths)
                    result.storyboardPaths.formUnion(files.storyboardPaths)
                }
        }

        func interfaceBuilderFiles(atPath path: URL) -> InterfaceBuilderFiles {
            var xibs: Set<URL> = []
            var storyboards: Set<URL> = []
            guard path.hasDirectoryPath else {
                switch path.pathExtension {
                case "xib": xibs.insert(path)
                case "storyboard": storyboards.insert(path)
                default: break
                }
                return InterfaceBuilderFiles(xibPaths: xibs, storyboardPaths: storyboards)
            }
            guard let enumerator = fileManager.enumerator(at: path, includingPropertiesForKeys: [.isRegularFileKey]) else {
                return InterfaceBuilderFiles(xibPaths: xibs, storyboardPaths: storyboards)
            }
            enumerator.compactMap { $0 as? URL }
                .forEach { url in
                    switch url.pathExtension {
                    case "xib": xibs.insert(url)
                    case "storyboard": storyboards.insert(url)
                    default: break
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
        case .xmlError(let error):
            return Violation(
                pathString: path.relativePath,
                message: "Parse XML error \(error)",
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
