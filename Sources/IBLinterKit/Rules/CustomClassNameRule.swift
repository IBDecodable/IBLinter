//
//  CustomClassNameRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import Foundation
import IBLinterCore

private extension StoryboardFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}

extension Rules {

    public struct CustomClassNameRule: Rule {

        public static let identifier: String = "custom_class_name"

        public init() {}

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            return storyboard.document.scenes?.flatMap { scene in
                guard let viewController = scene.viewController,
                    let customClass = viewController.customClass else { return nil }
                if customClass == storyboard.fileNameWithoutExtension { return nil }
                let message = "custom class name '\(customClass)' should be '\(storyboard.fileNameWithoutExtension)' "
                return Violation.init(interfaceBuilderFile: storyboard, message: message, level: .error)
            } ?? []
        }

        public func validate(xib: XibFile) -> [Violation] { return [] }
    }
}
