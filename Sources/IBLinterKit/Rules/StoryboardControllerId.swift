//
//  StoryboardControllerId.swift
//  IBLinterPackageDescription
//
//  Created by Majid Jabrayilov on 1/31/18.
//

import IBDecodable

extension Rules {

    public struct StoryboardViewControllerId: Rule {

        public static let identifier: String = "storyboard_viewcontroller_id"

        public init(context: Context) {}

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            let viewControllers = storyboard.document.scenes?.compactMap { $0.viewController }
            return viewControllers?.compactMap {
                $0.viewController.customClass != $0.viewController.storyboardIdentifier ?
                    Violation(pathString: storyboard.pathString,
                              message: "\(String(describing: $0.viewController.customClass)) should have the same Storyboard Id",
                        level: .error) : nil
                } ?? []
        }

        public func validate(xib: XibFile) -> [Violation] {
            return []
        }
    }
}
