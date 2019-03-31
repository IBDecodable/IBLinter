//
//  ForceToEnableAutoLayoutRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/15.
//

import IBDecodable

extension Rules {

    struct ForceToEnableAutoLayoutRule: Rule {

        static let identifier = "enable_autolayout"
        static let description = "Force to use useAutolayout option"
        static let isDefault = true

        init(context: Context) {}

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let useAutolayout = storyboard.document.useAutolayout else { return [] }
            return violation(useAutolayout: useAutolayout, file: storyboard)
        }

        func validate(xib: XibFile) -> [Violation] {
            guard let useAutolayout = xib.document.useAutolayout else { return [] }
            return violation(useAutolayout: useAutolayout, file: xib)
        }

        private func violation<T: InterfaceBuilderFile>(useAutolayout: Bool, file: T) -> [Violation] {
            let message = "\(file.fileName) is not enabled to use Autolayout."
            return useAutolayout ? [] : [Violation(pathString: file.pathString, message: message, level: .warning)]
        }
    }
}
