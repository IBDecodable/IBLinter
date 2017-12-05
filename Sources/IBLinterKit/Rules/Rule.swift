//
//  Rule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBLinterCore

public protocol Rule {
    init()
    static var identifier: String { get }
    func validate(storyboard: StoryboardFile) -> [Violation]
    func validate(xib: XibFile) -> [Violation]
}

public struct Rules {

    static var allRules: [Rule.Type] {
        return [
            CustomClassNameRule.self,
            RelativeToMarginRule.self
        ]
    }

    static var defaultRules: [Rule.Type] {
        return [
            CustomClassNameRule.self
        ]
    }

    static func rules(_ config: Config) -> [Rule] {
        return (defaultRules.filter { !config.disabledRules.contains($0.identifier) }
            + allRules.filter { config.enabledRules.contains($0.identifier) }).map { $0.init() }
    }
}
