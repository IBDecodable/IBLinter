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

        public func validate(xib: XibFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0, file: xib) }
        }

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.flatMap { $0.viewController?.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        private func validate(for view: ViewProtocol, file: FileProtocol) -> [Violation] {
            let violation: [Violation] = {
                if view.isMisplaced ?? false {
                    let message = "\(view.customClass ?? view.elementClass) is misplaced"
                    return [Violation(file: file, message: message, level: .error)]
                } else {
                    return []
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0, file: file) } ?? [])
        }
    }
}
