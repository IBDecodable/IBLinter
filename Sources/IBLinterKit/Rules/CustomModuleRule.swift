//
//  CustomModuleRule.swift
//  IBLinterKit
//
//  Created by FukagawaSatoru on 2018/7/3.
//

import Foundation
import IBDecodable
import SourceKittenFramework
import xcodeproj

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

    struct CustomModuleRule: Rule {

        static let identifier = "custom_module"
        static let description = "Check if custom class match custom module by custom_module_rule config."
        static let isDefault = true

        private var moduleClasses: [String:[String]] = [:]

        init(context: Context) {

            func classes(from path: URL) -> [String] {
                guard let file = SourceKittenFramework.File(path: path.relativePath),
                    let structure = try? Structure(file: file) else { return [] }
                return structure.dictionary.substructure.compactMap { dictionary in
                    guard let kind = dictionary.kind,
                        SwiftDeclarationKind(rawValue: kind) == .class else { return nil }
                    return dictionary.name
                }
            }

            moduleClasses = context.config.customModuleRule.reduce(into: [:]) { moduleClasses, customModuleConfig in
                let paths = customModuleConfig.included.flatMap { glob(pattern: "\($0)/**/*.swift") }
                let excluded = customModuleConfig.excluded.flatMap { glob(pattern: "\($0)/**/*.swift") }
                let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
                let classes: [String] = lintablePaths.flatMap(classes(from: ))
                moduleClasses[customModuleConfig.module] = classes
            }
        }

        func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib, fileNameWithoutExtension: xib.fileNameWithoutExtension) }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard, fileNameWithoutExtension: storyboard.fileNameWithoutExtension) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T, fileNameWithoutExtension: String) -> [Violation] {
            let violation: [Violation] = {
                guard let customClass = view.customClass else { return [] }
                guard let expectedModule = moduleClasses.first(where: { $0.value.contains(customClass) }) else {
                    return []
                }
                let message = "It does not match custom module rule in \(fileNameWithoutExtension). Custom module of \(customClass) is \(expectedModule.key)"
                let violation = Violation(pathString: file.pathString, message: message, level: .error)
                guard let customModule = view.customModule, expectedModule.key == customModule else {
                    return [violation]
                }
                return []
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file, fileNameWithoutExtension: fileNameWithoutExtension) } ?? [])
        }

    }
}

fileprivate extension Dictionary where Key: ExpressibleByStringLiteral {
    var substructure: [[String: SourceKitRepresentable]] {
        let substructure = self["key.substructure"] as? [SourceKitRepresentable] ?? []
        return substructure.compactMap { $0 as? [String: SourceKitRepresentable] }
    }
    var kind: String? {
        return self["key.kind"] as? String
    }
    var name: String? {
        return self["key.name"] as? String
    }
}
