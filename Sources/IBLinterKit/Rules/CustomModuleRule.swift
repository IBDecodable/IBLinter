//
//  CustomModuleRule.swift
//  IBLinterKit
//
//  Created by FukagawaSatoru on 2018/7/3.
//

import Foundation
import IBDecodable
import SourceKittenFramework
import xcproj

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

        private var moduleClasses: [String:[String]] = [:]

        public init(context: Context) {
            for customModuleConfig in context.config.customModuleRule {
                let paths = customModuleConfig.included.flatMap { glob(pattern: "\($0)/**/*.swift") }
                let excluded = customModuleConfig.excluded.flatMap { glob(pattern: "\($0)/**/*.swift") }
                let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
                var classes: [String] = []
                for path in lintablePaths {
                    let file = SourceKittenFramework.File(path: path.relativePath)
                    let fileClasses: [String] = file?.structure.dictionary.substructure.compactMap { dictionary in
                        if let kind = dictionary.kind, SwiftDeclarationKind(rawValue: kind) == .class {
                            return dictionary.name
                        }
                        return nil
                    } ?? []
                    classes += fileClasses
                }
                self.moduleClasses[customModuleConfig.module] = classes
            }
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
                for moduleName in moduleClasses.keys {
                    if let classes = moduleClasses[moduleName] {
                        if classes.contains(customClass) {
                            if let customModule = view.customModule {
                                if moduleName == customModule {
                                    return []
                                }
                            }
                            let message = "It does not match custom module rule in \(fileNameWithoutExtension). Custom module of \(customClass) is \(moduleName)"
                            return [Violation(pathString: file.pathString, message: message, level: .error)]
                        }
                    }
                }
                return []
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file, fileNameWithoutExtension: fileNameWithoutExtension) } ?? [])
        }

    }
}
