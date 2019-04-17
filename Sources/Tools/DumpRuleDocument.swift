//
//  DumpRuleDocument.swift
//  Tools
//
//  Created by Yuta Saito on 2019/03/31.
//

import Commandant
import Result
import IBLinterKit
import Darwin

struct DumpRuleDocument: CommandProtocol {

    let verb = "dump-rule-docs"
    let function = "Dump rule docs"

    typealias ClientError = CommandantError<()>
    struct Options: OptionsProtocol {
        typealias ClientError = CommandantError<()>
        let path: String?

        static func create(_ path: String?) -> Options {
            return self.init(path: path)
        }

        static func evaluate(_ mode: CommandMode) -> Result<Options, CommandantError<ClientError>> {
            return create
                <*> mode <| Option(
                    key: "path", defaultValue: nil,
                    usage: "The path where the documentation should be saved.")
        }
    }

    func run(_ options: Options) -> Result<(), ClientError> {
        let content = Rules.allRules.map { $0.dumpMarkdown() }.joined(separator: "\n\n")
        if let path = options.path {
            do {
                try content.write(toFile: path, atomically: true, encoding: .utf8)
            } catch {
                fputs("Something went wrong", stderr)
            }
        } else {
            print(content)
        }
        return .success(())
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
