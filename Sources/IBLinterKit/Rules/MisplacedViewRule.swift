//
//  MisplacedViewRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/15.
//

import IBLinterCore

extension Rules {

    public struct MisplacedViewRule: Rule {

        public static var identifier: String = "misplaced"

        public init() {}

        public func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib) }
        }

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.flatMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        private func validate(for view: ViewProtocol, file: InterfaceBuilderFile) -> [Violation] {
            let violation: [Violation] = {
                if view.misplaced ?? false {
                    let message = "\(view.customClass ?? view.elementClass) is misplaced"
                    return [Violation(interfaceBuilderFile: file, message: message, level: .error)]
                } else {
                    return []
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
