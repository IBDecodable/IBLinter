//
//  HasSingleViewControllerRule.swift
//  IBLinterKit
//
//  Created by Blazej SLEBODA on 24/03/2022
//

import IBDecodable

extension Rules {

    struct HasSingleViewControllerRule: Rule {

        static var identifier = "has_single_view_controller"
        static var description = "Checks if a storyboard has a single view controller, references are allowed"

        init(context: Context) { }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            Rules.violation(file: storyboard)
        }

        func validate(xib: XibFile) -> [Violation] { [] }

    }

    fileprivate static func violation(file: StoryboardFile) -> [Violation] {
        let numberOfViewControllersInStoryboard = file.document.scenes?.filter { $0.viewController != nil }.count ?? 0

        if numberOfViewControllersInStoryboard > 1 {
            return [Violation(pathString: file.pathString, message: "Should have only a single VC", level: .warning)]
        } else {
            return []
        }
    }

}
