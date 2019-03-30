//
//  StoryboardControllerId.swift
//  IBLinterPackageDescription
//
//  Created by Majid Jabrayilov on 1/31/18.
//

import IBDecodable

extension Rules {

    struct StoryboardViewControllerId: Rule {

        static let identifier: String = "storyboard_viewcontroller_id"
        static let description = "Check that Storyboard ID same as ViewController class name."

        init(context: Context) {}

        func validate(storyboard: StoryboardFile) -> [Violation] {
            let viewControllers = storyboard.document.scenes?.compactMap { $0.viewController }
            return viewControllers?.compactMap {
                $0.viewController.customClass != $0.viewController.storyboardIdentifier ?
                    Violation(pathString: storyboard.pathString,
                              message: "\(String(describing: $0.viewController.customClass)) should have the same Storyboard Id",
                        level: .error) : nil
                } ?? []
        }

        func validate(xib: XibFile) -> [Violation] {
            return []
        }
    }
}
