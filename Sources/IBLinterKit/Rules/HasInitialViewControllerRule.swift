//
//  HasInitialViewControllerRule.swift
//  IBLinterKit
//
//  Created by Blazej SLEBODA on 24/03/2022
//

import IBDecodable

extension Rules {

    struct HasInitialViewControllerRule: Rule {

        static var identifier = "has_initial_view_controller"
        static var description = "Checks if a storyboard has an initial view controller"

        init(context: Context) { }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            Rules.violation(file: storyboard)
        }

        func validate(xib: XibFile) -> [Violation] { [] }

    }

    fileprivate static func violation(file: StoryboardFile) -> [Violation] {
        if file.document.initialViewController == nil {
            return [Violation(pathString: file.pathString, message: "The storyboard must have an initial view controller", level: .warning)]
        } else {
            return []
        }
    }

}
