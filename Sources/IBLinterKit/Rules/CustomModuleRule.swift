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

            func resolvePath(_ includeURLString: String) -> URL {
                let url = URL(fileURLWithPath: includeURLString, relativeTo: context.workDirectory)
                return url.standardizedFileURL
            }
            func expandGlob(_ baseDirectory: URL) -> Set<URL> {
                return glob(pattern: baseDirectory.appendingPathComponent("**").appendingPathComponent("*.swift").path)
            }
            moduleClasses = context.config.customModuleRule.reduce(into: [:]) { moduleClasses, customModuleConfig in
                let paths = customModuleConfig.included.map(resolvePath).flatMap(expandGlob)
                let excluded = customModuleConfig.excluded.map(resolvePath).flatMap(expandGlob)
                let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
                let classes: [String] = lintablePaths.flatMap(classes(from: ))
                moduleClasses[customModuleConfig.module] = classes
            }
        }

        func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            let placeholders = xib.document.placeholders ?? []
            return views.flatMap { validate(for: $0.view, file: xib, fileNameWithoutExtension: xib.fileNameWithoutExtension) }
                + placeholders.flatMap { validate(forClassableObject: $0, file: xib, fileNameWithoutExtension: xib.fileNameWithoutExtension) }
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let viewControllers = scenes.compactMap { $0.viewController?.viewController }
            let views = viewControllers.compactMap { $0.rootView }
            return views.flatMap { validate(for: $0, file: storyboard, fileNameWithoutExtension: storyboard.fileNameWithoutExtension) }
                + viewControllers.flatMap { validate(forClassableObject: $0, file: storyboard, fileNameWithoutExtension: storyboard.fileNameWithoutExtension) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T, fileNameWithoutExtension: String) -> [Violation] {
            let violation = validate(forClassableObject: view, file: file, fileNameWithoutExtension: fileNameWithoutExtension)
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file, fileNameWithoutExtension: fileNameWithoutExtension) } ?? [])
        }

        private func validate<T: InterfaceBuilderFile>(
            forClassableObject classableObject: IBCustomClassable, file: T, fileNameWithoutExtension: String
        ) -> [Violation] {
            guard let customClass = classableObject.customClass else { return [] }
            let moduleCandidates = moduleClasses.lazy.filter({ $0.value.contains(customClass) }).map { $0.key }
            guard !moduleCandidates.isEmpty else { return [] }
            guard let customModule = classableObject.customModule, moduleCandidates.contains(customModule) else {
                let message = "It does not match custom module rule in \(fileNameWithoutExtension). Custom module of \(customClass) is one of [\(moduleCandidates.joined(separator: ", "))]"
                let violation = Violation(pathString: file.pathString, message: message, level: .error)
                return [violation]
            }
            return []
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
