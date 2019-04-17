//
//  Config+LintablePaths.swift
//  IBLinter
//
//  Created by Yuta Saito on 2018/10/16.
//

import Foundation

extension Config {
    public func lintablePaths(workDirectory: URL, fileExtension: String, fileManager: FileManager = .default) -> [URL] {
        let paths: Set<URL> = self.included.isEmpty ? glob(pattern: "\(workDirectory.path)/**/*.\(fileExtension)") : []
        let excluded: [URL] = self.excluded.flatMap { glob(pattern: workDirectory.appendingPathComponent("\($0)/**/*.\(fileExtension)").path) }
        let included: [URL] = self.included.flatMap { glob(pattern: workDirectory.appendingPathComponent("\($0)/**/*.\(fileExtension)").path) }
        let lintablePaths: [URL] = (paths + included).filter { (path: URL) -> Bool in
            return !excluded.contains { $0.absoluteString == path.absoluteString }
        }
        return lintablePaths
    }
}
