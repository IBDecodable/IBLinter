//
//  InterfaceBuilder.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/05.
//

public struct InterfaceBuilderParser {

    private let xmlParser: XMLParserProtocol

    public init(with parser: XMLParserProtocol) {
        xmlParser = parser
    }

    public func parseStoryboard(xml: String) throws -> InterfaceBuilderNode.StoryboardDocument {
        let root = xmlParser.parseString(xml)
        let document: XMLIndexerProtocol = try root.byKey("document")
        return try decodeValue(document)
    }

    public func parseXib(xml: String) throws -> InterfaceBuilderNode.XibDocument {
        let root = xmlParser.parseString(xml)
        let document: XMLIndexerProtocol = try root.byKey("document")
        return try decodeValue(document)
    }
}
