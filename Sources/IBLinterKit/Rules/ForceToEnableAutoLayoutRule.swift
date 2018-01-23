//
//  ForceToEnableAutoLayoutRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/15.
//

import IBLinterCore

extension Rules {

    public struct ForceToEnableAutoLayoutRule: Rule {

        public static var identifier: String = "enable_autolayout"

        public init() {}

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let useAutolayout = storyboard.document.useAutolayout else { return [] }
            return violation(useAutolayout: useAutolayout, file: storyboard)
        }

        public func validate(xib: XibFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let useAutolayout = xib.document.useAutolayout else { return [] }
            return violation(useAutolayout: useAutolayout, file: xib)
        }

        private func violation(useAutolayout: Bool, file: FileProtocol) -> [Violation] {
            let message = "\(file.fileName) is not enabled to use Autolayout."
            return useAutolayout ? [] : [Violation(file: file, message: message, level: .warning)]
        }
    }
}
