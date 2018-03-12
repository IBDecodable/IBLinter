//
//  StoryboardControllerId.swift
//  IBLinterPackageDescription
//
//  Created by Majid Jabrayilov on 1/31/18.
//

import IBLinterCore

public extension Rules {

    public struct StoryboardViewControllerId: Rule {

        public static let identifier: String = "storyboard_viewcontroller_id"

        public init() {}

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            let viewControllers = storyboard.document.scenes?.flatMap { $0.viewController }
            return viewControllers?.flatMap {
                $0.viewController.customClass != $0.viewController.storyboardIdentifier ?
                    Violation(interfaceBuilderFile: storyboard,
                              message: "\(String(describing: $0.viewController.customClass)) should have the same Storyboard Id",
                        level: .error) : nil
                } ?? []
        }

        public func validate(xib: XibFile) -> [Violation] {
            return []
        }
    }
}
