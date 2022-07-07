//
//  CustomViewRule.swift
//  
//
//  Created by Blazej Sleboda on 07/07/2022.
//

import Foundation
import IBDecodable
import SourceKittenFramework

extension Rules {
    struct CustomViewRule: Rule {

        static var identifier = "custom_view"
        static var description = "Emits warnings if storyboard scenes contain custom views"

        init(context: Context) { }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            return scenes.map { scene in
                scene.customViews?.map { anyView in
                    let viewId = (anyView as? IBIdentifiable)?.id ?? "non identifiable"
                    return Violation(pathString: storyboard.pathString, message: "Custom view is not allowed (\(viewId) of Scene: \(scene.id)", level: .warning)
                } ?? [Violation]()
            }.flatMap { $0 }
        }

        func validate(xib: XibFile) -> [Violation] { [] }

    }
}
