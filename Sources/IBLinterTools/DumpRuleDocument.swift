//
//  DumpRuleDocument.swift
//  IBLinterTools
//
//  Created by Yuta Saito on 2019/03/31.
//

import ArgumentParser
import IBLinterKit
#if os(Linux)
import Glibc
#else
import Darwin
#endif

struct DumpRuleDocument: ParsableCommand {

    static let configuration = CommandConfiguration(commandName: "dump-rule-docs", abstract: "Dump rule docs")

    @Option(help: "The path where the documentation should be saved.")
    var path: String?

    func run() throws {
        let content = Rules.allRules.map { $0.dumpMarkdown() }.joined(separator: "\n\n")
        if let path = path {
            do {
                try content.write(toFile: path, atomically: true, encoding: .utf8)
            } catch {
                throw ValidationError("Something went wrong")
            }
        } else {
            print(content)
        }
    }
}

extension Rule {
    static func dumpMarkdown() -> String {
        return """
## \(_typeName(self, qualified: false))

|    identifier   | `\(identifier)` |
|:---------------:|:---------------:|
|   Default Rule  |  `\(isDefault)` |

\(description)

"""
    }
}
