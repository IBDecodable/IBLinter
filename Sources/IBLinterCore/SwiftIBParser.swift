//
//  SwiftIBParser.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2018/01/06.
//

import Foundation
import SourceKittenFramework

public class SwiftIBParser {

    public struct Class {
        let name: String
        let outlets: [Declaration]
        let actions: [Declaration]

        public init(name: String, outlets: [Declaration], actions: [Declaration]) {
            self.name = name
            self.outlets = outlets
            self.actions = actions
        }
    }

    public struct Declaration {
        let name: String
        let line: Int
        let column: Int
        let url: URL?
        let isOptional: Bool

        public init(name: String, line: Int, column: Int, url: URL? = nil, isOptional: Bool = false) {
            self.name = name
            self.line = line
            self.column = column
            self.url = url
            self.isOptional = isOptional
        }

        init(name: String, file: File, offset: Int64, isOptional: Bool = false) {
            let fileOffset = type(of: self).getLineColumnNumber(of: file, offset: Int(offset))
            var url: URL?
            if let path = file.path {
                url = URL(fileURLWithPath: path)
            }
            self.init(name: name, line: fileOffset.line, column: fileOffset.column, url: url, isOptional: isOptional)
        }

        private static func getLineColumnNumber(of file: File, offset: Int) -> (line: Int, column: Int) {
            let range = file.contents.startIndex..<file.contents.index(file.contents.startIndex, offsetBy: offset)
            let subString = file.contents[range]
            let lines = subString.components(separatedBy: "\n")

            if let column = lines.last?.characters.count {
                return (line: lines.count, column: column)
            }
            return (line: lines.count, column: 0)
        }
    }

    public private(set) var classNameToStructure: [String: Class] = [:]

    public init(swiftFilePaths: [String]) {

        swiftFilePaths.forEach(mappingFile)
    }

    private func mappingFile(at path: String) {
        guard let file = File(path: path) else { return }
        let fileStructure = Structure(file: file)

        fileStructure.dictionary.substructure.forEach { [weak self] structure in
            var outlets: [Declaration] = []
            var actions: [Declaration] = []

            guard let kind = structure["key.kind"] as? String, let name = structure["key.name"] as? String,
                kind == "source.lang.swift.decl.class" || kind == "source.lang.swift.decl.extension" else { return }

            structure.substructure.forEach { insideStructure in
                guard let attributes = insideStructure["key.attributes"] as? [[String: String]],
                    let propertyName = insideStructure["key.name"] as? String else { return }

                let isOutlet = attributes.contains { $0.values.contains("source.decl.attribute.iboutlet") }
                if isOutlet, let nameOffset64 = insideStructure["key.nameoffset"] as? Int64 {
                    outlets.append(Declaration(name: propertyName, file: file, offset: nameOffset64, isOptional: insideStructure.isOptional))
                }

                let isIBAction = attributes.contains { $0.values.contains("source.decl.attribute.ibaction") }

                if isIBAction, let selectorName = insideStructure["key.selector_name"] as? String,
                    let nameOffset64 = insideStructure["key.nameoffset"] as? Int64 {
                    actions.append(Declaration(name: selectorName, file: file, offset: nameOffset64))
                }
            }

            self?.classNameToStructure[name] = Class.init(name: name, outlets: outlets, actions: actions)
        }
    }
}

private extension Dictionary where Key: ExpressibleByStringLiteral {
    var substructure: [[String: SourceKitRepresentable]] {
        let substructure = self["key.substructure"] as? [SourceKitRepresentable] ?? []
        return substructure.flatMap { $0 as? [String: SourceKitRepresentable] }
    }

    var isOptional: Bool {
        if let typename = self["key.typename"] as? String,
            let optionalString = typename.characters.last {
            return optionalString == "?"
        }
        return false
    }
}

extension SwiftIBParser.Class: Equatable {
    public static func ==(lhs: SwiftIBParser.Class, rhs: SwiftIBParser.Class) -> Bool {
        return lhs.actions == rhs.actions && lhs.name == rhs.name && lhs.outlets == rhs.outlets
    }
}

extension SwiftIBParser.Declaration: Equatable {
    public static func ==(lhs: SwiftIBParser.Declaration, rhs: SwiftIBParser.Declaration) -> Bool {
        return lhs.column == rhs.column &&
               lhs.isOptional == rhs.isOptional &&
               lhs.line == rhs.line &&
               lhs.name == rhs.name &&
               lhs.url == rhs.url
    }
}
