//
//  RelativeToMarginRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/12.
//

import IBDecodable

extension Rules {

    public struct RelativeToMarginRule: Rule {

        public static let identifier: String = "relative_to_margin"

        public init(context: Context) {}

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            let scenes = storyboard.document.scenes
            let viewControllers = scenes?.compactMap { $0.viewController }
            return viewControllers?.compactMap { $0.viewController.rootView }
                .flatMap { validate(for: $0, file: storyboard) } ?? []
        }

        public func validate(xib: XibFile) -> [Violation] {
            return xib.document.views?.flatMap { validate(for: $0.view, file: xib) } ?? []
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            guard let constraints = view.constraints else { return view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [] }
            let relativeToMarginKeys: [Constraint.LayoutAttribute] = [
                .leadingMargin, .trailingMargin, .topMargin, .bottomMargin
            ]
            let attributes = constraints.flatMap { [$0.firstAttribute, $0.secondAttribute] }.compactMap { $0 }
            let violations: [Violation] = attributes.filter { relativeToMarginKeys.contains($0) }
                .map { at in
                    let message = " \(at) is deprecated in \(view.customClass ?? view.elementClass)"
                    return Violation.init(pathString: file.pathString, message: message, level: .warning)
            }
            if let subviews = view.subviews {
                return subviews.flatMap { validate(for: $0.view, file: file) } + violations
            } else {
                return violations
            }
        }
    }
}
