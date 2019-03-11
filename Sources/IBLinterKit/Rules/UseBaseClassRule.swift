//
//  UseBaseClassRule.swift
//  IBLinterKit
//
//  Created by masamichi on 2019/03/07.
//

import Foundation
import IBDecodable

private extension XibFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}

private extension StoryboardFile {
    var fileExtension: String {
        return URL.init(fileURLWithPath: pathString).pathExtension
    }
    var fileNameWithoutExtension: String {
        return fileName.replacingOccurrences(of: ".\(fileExtension)", with: "")
    }
}

extension Rules {
    public struct UseBaseClassRule: Rule {
        public init(context: Context) {}

        public static var identifier: String = "use_base_class"

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard, fileNameWithoutExtension: storyboard.fileNameWithoutExtension) }
        }

        public func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib, fileNameWithoutExtension: xib.fileNameWithoutExtension) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T, fileNameWithoutExtension: String) -> [Violation] {
            return []
        }
    }
}
