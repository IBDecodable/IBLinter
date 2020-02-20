//
//  UseColorRule.swift
//  IBLinterKit
//
//  Created by Mark Fernandez on 2020/02/19.
//

import Foundation
import IBDecodable

extension Rules {
    struct UseColorRule: Rule {

        static let identifier = "use_color_rule"
        static let description = "Check if colors used are valid"

        private var allowedColors: [String] = []

        init(context: Context) {
            for useColorConfig in context.config.useColorRule {
                self.allowedColors.append(contentsOf: useColorConfig.allowedColors)
            }
        }

        func validate(xib: XibFile) -> [Violation] {
            return validate(
                for: xib.document.children(of: NamedColor.self),
                file: xib
            )
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            return validate(
                for: storyboard.document.children(of: NamedColor.self),
                file: storyboard
            )
        }

        private func validate<T: InterfaceBuilderFile>(for colors: [NamedColor], file: T) -> [Violation] {
            return colors
                .map { $0.name }
                .filter { !self.allowedColors.contains($0) }
                .map {
                    Violation(
                        pathString: file.pathString,
                        message: "\($0) not a allowed color",
                        level: .error)
            }
        }
    }
}
