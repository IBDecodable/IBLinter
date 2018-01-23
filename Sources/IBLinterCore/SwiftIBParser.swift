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
        public let file: SwiftFile
        public let name: String
        public fileprivate(set) var connections: [Connection]
        public let inheritedClassNames: [String]
        public let declaration: Declaration

        public init(file: SwiftFile, name: String, connections: [Connection],
                    inheritedClassNames: [String], declaration: Declaration) {
            self.file = file
            self.name = name
            self.connections = connections
            self.declaration = declaration
            self.inheritedClassNames = inheritedClassNames
        }
    }

    public enum Connection {
        case action(selector: String, declaration: Declaration)
        case outlet(property: String, isOptional: Bool, declaration: Declaration)
    }

    public struct Declaration {

        public let line: Int
        public let column: Int
        public let path: String?

        public init(line: Int, column: Int, path: String?) {
            self.line = line
            self.column = column
            self.path = path
        }

        public init(file: File, offset: Int64) {
            let fileOffset = type(of: self).getLineColumnNumber(of: file, offset: Int(offset))

            self.line = fileOffset.line
            self.column = fileOffset.column
            // SourceKitten use no file scheme prefix path
            self.path = file.path.map { URL.init(fileURLWithPath: $0).absoluteString }
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
            var connections: [Connection] = []

            guard let kind = structure["key.kind"] as? String, let name = structure["key.name"] as? String,
                kind == "source.lang.swift.decl.class" || kind == "source.lang.swift.decl.extension" else { return }

            structure.substructure.forEach { insideStructure in
                guard let attributes = insideStructure["key.attributes"] as? [[String: String]],
                    let propertyName = insideStructure["key.name"] as? String else { return }

                let isOutlet = attributes.contains { $0.values.contains("source.decl.attribute.iboutlet") }
                if isOutlet, let nameOffset64 = insideStructure["key.nameoffset"] as? Int64 {
                    connections.append(.outlet(property: propertyName, isOptional: insideStructure.isOptional,
                                               declaration: .init(file: file, offset: nameOffset64)))
                }

                let isIBAction = attributes.contains { $0.values.contains("source.decl.attribute.ibaction") }

                if isIBAction, let selectorName = insideStructure["key.selector_name"] as? String,
                    let nameOffset64 = insideStructure["key.nameoffset"] as? Int64 {
                    connections.append(.action(selector: selectorName,
                                               declaration: .init(file: file, offset: nameOffset64)))
                }
            }

            if self?.classNameToStructure[name] == nil {
                guard let nameOffset64 = structure["key.nameoffset"] as? Int64,
                    let inheritedTypes = structure["key.inheritedtypes"] as? [[String: String]] else { return }

                self?.classNameToStructure[name] = Class(file: SwiftFile(path: path),
                                                         name: name, connections: connections,
                                                         inheritedClassNames: inheritedTypes.flatMap { $0["key.name"] },
                                                         declaration: .init(file: file, offset: nameOffset64))
            } else {
                self?.classNameToStructure[name]?.connections.append(contentsOf: connections)
            }
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
        return lhs.name == rhs.name && lhs.connections == rhs.connections
    }
}

extension SwiftIBParser.Connection: Equatable {
    public static func ==(lhs: SwiftIBParser.Connection, rhs: SwiftIBParser.Connection) -> Bool {
        switch (lhs, rhs) {
        case (.action(let selector1, let declaration1),
              .action(let selector2, let declaration2)):
            return selector1 == selector2 && declaration1 == declaration2
        case (.outlet(let property1, let isOptional1, let declaration1),
              .outlet(let property2, let isOptional2, let declaration2)):
            return property1 == property2 && isOptional1 == isOptional2 && declaration1 == declaration2
        default: return false
        }
    }
}

extension SwiftIBParser.Declaration: Equatable {
    public static func ==(lhs: SwiftIBParser.Declaration, rhs: SwiftIBParser.Declaration) -> Bool {
        return lhs.column == rhs.column &&
               lhs.line == rhs.line &&
               lhs.path == rhs.path
    }
}
