//
//  MisplacedViewRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/15.
//

import IBDecodable

extension Rules {

    struct MisplacedViewRule: Rule {

        static let identifier = "misplaced"
        static let description = "Display error when views are misplaced."

        init(context: Context) {}

        func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib) }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            let violation: [Violation] = {
                if view.isMisplaced ?? false {
                    let message = "\(view.customClass ?? view.elementClass) is misplaced"
                    return [Violation(pathString: file.pathString, message: message, level: .error)]
                } else {
                    return []
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
