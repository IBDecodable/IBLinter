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
            RelativeToMarginRule.self,
            MisplacedViewRule.self,
            ForceToEnableAutoLayoutRule.self,
            DuplicateConstraintRule.self,
            StoryboardViewControllerId.self
        ]
    }

    static var defaultRules: [Rule.Type] {
        return [
            CustomClassNameRule.self,
            ForceToEnableAutoLayoutRule.self,
            DuplicateConstraintRule.self
        ]
    }

    static func rules(_ config: Config) -> [Rule] {
        var identifiers = Set(defaultRules.map({ $0.identifier }))
        identifiers.subtract(config.disabledRules)
        identifiers.formUnion(config.enabledRules)
        
        return allRules.filter { identifiers.contains($0.identifier) }.map { $0.init() }
    }
}
