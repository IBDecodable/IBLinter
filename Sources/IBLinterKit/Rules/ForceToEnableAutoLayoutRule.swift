//
//  ForceToEnableAutoLayoutRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/15.
//

import IBDecodable

extension Rules {

    public struct ForceToEnableAutoLayoutRule: Rule {

        public static var identifier: String = "enable_autolayout"

        public init(context: Context) {}

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let useAutolayout = storyboard.document.useAutolayout else { return [] }
            return violation(useAutolayout: useAutolayout, file: storyboard)
        }

        public func validate(xib: XibFile) -> [Violation] {
            guard let useAutolayout = xib.document.useAutolayout else { return [] }
            return violation(useAutolayout: useAutolayout, file: xib)
        }

        private func violation<T: InterfaceBuilderFile>(useAutolayout: Bool, file: T) -> [Violation] {
            let message = "\(file.fileName) is not enabled to use Autolayout."
            return useAutolayout ? [] : [Violation(pathString: file.pathString, message: message, level: .warning)]
        }
    }
}
