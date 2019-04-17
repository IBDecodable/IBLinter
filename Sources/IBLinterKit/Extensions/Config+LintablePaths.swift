//
//  Config+LintablePaths.swift
//  IBLinter
//
//  Created by Yuta Saito on 2018/10/16.
//

import Foundation

private struct InterfaceBuilderFiles {
    var xib: Set<URL> = []
    var storyboard: Set<URL> = []
}

extension Config {
    public func lintablePaths(workDirectory: URL, fileManager: FileManager = .default) -> (xib: Set<URL>, storyboard: Set<URL>) {
        let matcher = LintableFileMatcher(fileManager: fileManager)
        let files: InterfaceBuilderFiles
        if included.isEmpty {
            files = matcher.interfaceBuilderFiles(atPath: workDirectory)
        } else {
            files = matcher.interfaceBuilderFiles(
                withPatterns: self.included.map { workDirectory.appendingPathComponent($0) }
            )
        }

        let excluded = matcher.interfaceBuilderFiles(
            withPatterns: self.excluded.map { workDirectory.appendingPathComponent($0) }
        )
        let xibLintablePaths = files.xib.subtracting(excluded.xib)
        let storyboardLintablePaths = files.storyboard.subtracting(excluded.storyboard)
        return (xibLintablePaths, storyboardLintablePaths)
    }
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
                result.xib.formUnion(files.xib)
                result.storyboard.formUnion(files.storyboard)
        }
    }

    func interfaceBuilderFiles(atPath path: URL) -> InterfaceBuilderFiles {
        var xibs: Set<URL> = []
        var storyboards: Set<URL> = []
        guard let enumerator = fileManager.enumerator(at: path, includingPropertiesForKeys: [.isRegularFileKey]) else {
            return InterfaceBuilderFiles(xib: xibs, storyboard: storyboards)
        }

        for element in enumerator {
            guard let absolute = element as? URL else { continue }
            switch absolute.pathExtension {
            case "xib": xibs.insert(absolute)
            case "storyboard": storyboards.insert(absolute)
            default: continue
            }
        }
        return InterfaceBuilderFiles(xib: xibs, storyboard: storyboards)
    }
}
