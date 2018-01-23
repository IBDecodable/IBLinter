//
//  StoryboardFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

import SWXMLHash
import Foundation

public class StoryboardFile: InterfaceBuilderFile {
    public var pathString: String
    public var fileName: String {
        return pathString.components(separatedBy: "/").last!
    }

    public let document: InterfaceBuilderNode.StoryboardDocument

    public init(path: String, xmlParser: XMLParserProtocol = SWXMLHash.config { _ in }) throws {
        self.pathString = path
        self.document = try type(of: self).parseContent(xmlParser: xmlParser, pathString: path)
    }

    private static func parseContent(xmlParser: XMLParserProtocol, pathString: String) throws -> InterfaceBuilderNode.StoryboardDocument {
        let parser = InterfaceBuilderParser.init(with: xmlParser)
        let content = try String.init(contentsOfFile: pathString)
        return try parser.parseStoryboard(xml: content)
    }
}
