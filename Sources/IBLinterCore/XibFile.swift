//
//  XibFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/13.
//

import SWXMLHash
import Foundation

public class XibFile: InterfaceBuilderFile {
    public var pathString: String
    public var fileName: String {
        return pathString.components(separatedBy: "/").last!
    }

    public let document: InterfaceBuilderNode.XibDocument

    public init(path: String, xmlParser: XMLParserProtocol = SWXMLHash.config { _ in }) throws {
        self.pathString = path
        self.document = try type(of: self).parseContent(xmlParser: xmlParser, pathString: path)
    }

    private static func parseContent(xmlParser: XMLParserProtocol, pathString: String) throws -> InterfaceBuilderNode.XibDocument {
        let parser = InterfaceBuilderParser.init(with: xmlParser)
        let content = try String.init(contentsOfFile: pathString)
        return try parser.parseXib(xml: content)
    }
}
