//
//  CustomObjectRule.swift
//  IBLinterKit
//
//  Created by Blazej Sleboda on 05/07/2022.
//

import IBDecodable

extension Rules {

    struct CustomObjectRule: Rule {

        static var identifier = "custom_object"
        static var description = "Emits warnings if storyboard scenes contain custom objects"

        init(context: Context) { }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            return scenes.map { scene in
                scene.customObjects?.map { customObject in
                    Violation(pathString: storyboard.pathString, message: "Custom object is not allowed (\(customObject.id) of Scene: \(scene.id)", level: .warning)
                } ?? [Violation]()
            }.flatMap { $0 }
        }

        func validate(xib: XibFile) -> [Violation] { [] }

    }
}
