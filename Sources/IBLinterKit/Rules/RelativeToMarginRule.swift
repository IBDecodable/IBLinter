//
//  RelativeToMarginRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/12.
//

import IBLinterCore

public extension Rules {

    public struct RelativeToMarginRule: Rule {

        public static let identifier: String = "relative_to_margin"

        public init() {}

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            let scenes = storyboard.document.scenes
            let viewControllers = scenes?.flatMap { $0.viewController }
            return viewControllers?.flatMap { $0.rootView }
                .flatMap { validate(for: $0, file: storyboard) } ?? []
        }

        public func validate(xib: XibFile, swiftParser: SwiftIBParser) -> [Violation] {
            return xib.document.views?.flatMap { validate(for: $0, file: xib) } ?? []
        }

        private func validate(for view: ViewProtocol, file: FileProtocol) -> [Violation] {
            guard let constraints = view.constraints else { return view.subviews?.flatMap { validate(for: $0, file: file) } ?? [] }
            let relativeToMarginKeys: [InterfaceBuilderNode.View.Constraint.LayoutAttribute] = [
                .leadingMargin, .trailingMargin, .topMargin, .bottomMargin
            ]
            let attributes = constraints.flatMap { [$0.firstAttribute, $0.secondAttribute] }.flatMap { $0 }
            let violations: [Violation] = attributes.filter { relativeToMarginKeys.contains($0) }
                .map { at in
                    let message = " \(at) is deprecated in \(view.customClass ?? view.elementClass)"
                    return Violation.init(file: file, message: message, level: .warning)
            }
            if let subviews = view.subviews {
                return subviews.flatMap { validate(for: $0, file: file) } + violations
            } else {
                return violations
            }
        }
    }
}
