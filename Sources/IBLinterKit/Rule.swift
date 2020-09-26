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
    static var description: String { get }
    static var isDefault: Bool { get }
    func validate(storyboard: StoryboardFile) -> [Violation]
    func validate(xib: XibFile) -> [Violation]
}

extension Rule {
    public static var isDefault: Bool { return false }
}

public struct Rules {

    public private(set) static var allRules: [Rule.Type] = {
        return [
            CustomClassNameRule.self,
            RelativeToMarginRule.self,
            MisplacedViewRule.self,
            ForceToEnableAutoLayoutRule.self,
            DuplicateConstraintRule.self,
            DuplicateIDRule.self,
            StoryboardViewControllerId.self,
            StackViewBackgroundColorRule.self,
            ImageResourcesRule.self,
            CustomModuleRule.self,
            UseBaseClassRule.self,
            AmbiguousViewRule.self,
            UseTraitCollections.self,
            ViewAsDeviceRule.self,
            ReuseIdentifierRule.self,
            ColorResourcesRule.self
        ]
    }()

    static var defaultRules: [Rule.Type] {
        return allRules.filter { $0.isDefault }
    }

    public static func rules(_ context: Context) -> [Rule] {
        var identifiers = Set(defaultRules.map({ $0.identifier }))
        identifiers.subtract(context.config.disabledRules)
        identifiers.formUnion(context.config.enabledRules)
        let rules = allRules + context.externalRules

        return rules.filter { identifiers.contains($0.identifier) }.map { $0.init(context: context) }
    }
}
