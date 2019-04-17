//
//  CustomClassNameRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

import Foundation
import IBDecodable

private extension StoryboardFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}

extension Rules {

    struct CustomClassNameRule: Rule {

        static let identifier: String = "custom_class_name"
        static let description: String = "Custom class name of ViewController in storyboard should be same as file name."

        init(context: Context) {}

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let viewController = storyboard.document.scenes?.first?.viewController,
                let customClass = viewController.viewController.customClass,
                storyboard.document.scenes?.count == 1,
                storyboard.fileNameWithoutExtension != "Main" else {
                // Skip when storyboard has multiple view controllers or Main.storyboard.
                return []
            }
            if customClass == storyboard.fileNameWithoutExtension { return [] }
            let message: String = "custom class name '\(customClass)' should be '\(storyboard.fileNameWithoutExtension)' "
            return [Violation.init(pathString: storyboard.pathString, message: message, level: .error)]
        }

        func validate(xib: XibFile) -> [Violation] { return [] }
    }
}
