//
//  CustomModuleRule.swift
//  IBLinterKit
//
//  Created by FukagawaSatoru on 2018/7/3.
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

    public struct CustomModuleRule: Rule {

        public static let identifier: String = "custom_module"
        private let context: Context

        public init(context: Context) {
            self.context = context
        }

        public func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib, fileNameWithoutExtension: xib.fileNameWithoutExtension) }
        }

        public func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard, fileNameWithoutExtension: storyboard.fileNameWithoutExtension) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T, fileNameWithoutExtension: String) -> [Violation] {
            let violation: [Violation] = {
                guard let customClass = view.customClass else { return [] }
                for customModuleConfig in context.config.customModuleRule {
                    if customModuleConfig.classes.contains(customClass) {
                        if let customModule = view.customModule {
                            if customModuleConfig.module == customModule {
                                return []
                            }
                        }
                        let message = "It does not match custom module rule in \(fileNameWithoutExtension). Custom module of \(customClass) is \(customModuleConfig.module)"
                        return [Violation(pathString: file.pathString, message: message, level: .error)]
                    }
                }
                return []
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file, fileNameWithoutExtension: fileNameWithoutExtension) } ?? [])
        }

    }
}
