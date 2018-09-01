//
//  Rule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import IBDecodable

public protocol Rule {
    init(context: Context)
    static var identifier: String { get }
    func validate(storyboard: StoryboardFile) -> [Violation]
    func validate(xib: XibFile) -> [Violation]
}

public struct Rules {

    static var allRules: [Rule.Type] = {
        return [
            CustomClassNameRule.self,
            RelativeToMarginRule.self,
            MisplacedViewRule.self,
            ForceToEnableAutoLayoutRule.self,
            DuplicateConstraintRule.self,
            StoryboardViewControllerId.self,
            ImageResourcesRule.self,
        ]
    }()

    static var defaultRules: [Rule.Type] {
        return [
            CustomClassNameRule.self,
            ForceToEnableAutoLayoutRule.self,
            DuplicateConstraintRule.self
        ]
    }

    public static func rules(_ context: Context) -> [Rule] {
        var identifiers = Set(defaultRules.map({ $0.identifier }))
        identifiers.subtract(context.config.disabledRules)
        identifiers.formUnion(context.config.enabledRules)
        let rules = allRules + context.externalRules

        return rules.filter { identifiers.contains($0.identifier) }.map { $0.init(context: context) }
    }
}
