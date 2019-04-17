//
//  EmojiReporter.swift
//  IBLinterKit
//
//  Created by phimage on 20/04/2018.
//

import Foundation

struct EmojiReporter: Reporter {
    public static let identifier: String = "emoji"

    public static func generateReport(violations: [Violation]) -> String {
        return violations.group { violation in
            violation.pathString
            }.map(report).joined(separator: "\n")
    }

    private static func report(for file: String, with violations: [Violation]) -> String {
        let lines: [String] = [file] + violations.sorted(by: { lhs, rhs in
            return lhs.level > rhs.level
        }).map { (violation: Violation) -> String in
            let emoji: String = (violation.level == .error) ? "⛔️" : "⚠️"
            return "\(emoji) \(violation.message)"
        }
        return lines.joined(separator: "\n")
    }

}

extension Array {
    func group<U: Hashable>(by transform: (Element) -> U) -> [U: [Element]] {
        return reduce([:]) { (dictionary: [U : [Element]], element: Element) -> [U : [Element]] in
            var dictionary: [U : [Element]] = dictionary
            let key: U = transform(element)
            dictionary[key] = (dictionary[key] ?? []) + [element]
            return dictionary
        }
    }
}
