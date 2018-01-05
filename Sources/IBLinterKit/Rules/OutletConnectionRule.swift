//
//  OutletConnectionRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/01/04.
//

import IBLinterCore

extension Rules {

    public struct OutletConnectionRule: Rule {

        public static var identifier: String = "outlet_connection"

        public init() {}

        public func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0, file: xib) }
        }

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let viewControllers = scenes.flatMap { $0.viewController }
            let views = viewControllers.flatMap { $0.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) } +
                viewControllers.flatMap { validate(for: $0, file: storyboard) }
        }

        private func validate(for view: ViewProtocol, file: InterfaceBuilderFile) -> [Violation] {
            var customClassOutlets: [String: [InterfaceBuilderNode.View.Connection]] = [:]
            view.customClass
                .map { customClassOutlets[$0] = view.connections ?? [] }
            fatalError()
        }

        private func validate(for viewController: ViewControllerProtocol, file: InterfaceBuilderFile) -> [Violation] {
            var customClassOutlets: [String: [InterfaceBuilderNode.View.Connection]] = [:]
            fatalError()
        }
    }
}
