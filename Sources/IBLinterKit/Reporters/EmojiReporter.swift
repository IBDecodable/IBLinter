//
//  EmojiReporter.swift
//  IBLinterKit
//
//  Created by phimage on 20/04/2018.
//

import Foundation

struct EmojiReporter: Reporter {
    public static let identifier = "emoji"

    public static func generateReport(violations: [Violation]) -> String {
        return violations.group { violation in
            violation.interfaceBuilderFile.pathString
            }.map(report).joined(separator: "\n")
    }

    private static func report(for file: String, with violations: [Violation]) -> String {
        let lines = [file] + violations.sorted(by: { lhs, rhs in
            return lhs.level > rhs.level
        }).map { violation in
            let emoji = (violation.level == .error) ? "⛔️" : "⚠️"
            return "\(emoji) \(violation.message)"
        }
        return lines.joined(separator: "\n")
    }

}

extension Array {
    func group<U: Hashable>(by transform: (Element) -> U) -> [U: [Element]] {
        return reduce([:]) { dictionary, element in
            var dictionary = dictionary
            let key = transform(element)
            dictionary[key] = (dictionary[key] ?? []) + [element]
            return dictionary
        }
    }
}
