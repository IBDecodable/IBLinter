//
//  Config+LintablePaths.swift
//  IBLinter
//
//  Created by Yuta Saito on 2018/10/16.
//

import Foundation

extension Config {
    public func lintablePaths(workDirectory: URL, fileExtension: String, fileManager: FileManager = .default) -> [URL] {
        let paths = self.included.isEmpty ? glob(pattern: "\(workDirectory.path)/**/*.\(fileExtension)") : []
        let excluded = self.excluded.flatMap { glob(pattern: workDirectory.appendingPathComponent("\($0)/**/*.\(fileExtension)").path) }
        let included = self.included.flatMap { glob(pattern: workDirectory.appendingPathComponent("\($0)/**/*.\(fileExtension)").path) }
        let lintablePaths = (paths + included).filter { path in
            return !excluded.contains { $0.absoluteString == path.absoluteString }
        }
        return lintablePaths
    }
}
