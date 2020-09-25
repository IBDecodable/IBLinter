//
//  UseTraitCollections.swift
//  IBLinterKit
//
//  Created by Blazej SLEBODA on 13/09/2020
//

import IBDecodable

extension Rules {

    struct UseTraitCollections: Rule {

        static var identifier = "use_trait_collections"
        static var description = "Check id document useTraitCollections is enabled or diasbled"
        let enabled: Bool

        init(context: Context) {
            if let configUseTraitCollectionRule = context.config.useTraitCollectionsRule {
                enabled = configUseTraitCollectionRule.enabled
            } else {
                enabled = true
            }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            Rules.violation(enabled, file: storyboard)
        }

        func validate(xib: XibFile) -> [Violation] {
            Rules.violation(enabled, file: xib)
        }

    }

    fileprivate static func violation<T: InterfaceBuilderFile>(_ enabled: Bool, file: T) -> [Violation] {

        guard let document = file.document as? InterfaceBuilderDocument else {
            return []
        }

        if enabled {
            if document.useTraitCollections == .some(true) {
                return []
            } else {
                return [Violation(pathString: file.pathString, message: "useTraitCollection must be enabled", level: .warning)]
            }
        } else {
            if [Bool?(false), .none].contains(document.useTraitCollections) {
                return []
            } else {
                return [Violation(pathString: file.pathString, message: "useTraitCollection must be disabled", level: .warning)]
            }
        }
    }

}
