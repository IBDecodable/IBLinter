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

        static let identifier = "use_color"
        static let description = "Check if colors used are valid"

        private var allowedColors: [String] = []

        init(context: Context) {
            for useColorConfig in context.config.useColorRule {
                self.allowedColors.append(contentsOf: useColorConfig.allowedColors)
            }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            let violation: [Violation] = {
                let colors = view.children(of: Color.self)
                for i in colors {
                    if i.sRGB != nil {
                        let message = "Custom color used in \(viewName(of: view))"
                        return [Violation(pathString: file.pathString, message: message, level: .error)]
                    }
                }
                return []
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
