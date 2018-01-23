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
        guard let document: XMLIndexerProtocol = root.byKey("document") else {
            throw Error.invalidFormatFile
        }
        return try decodeValue(document)
    }

    public func parseXib(xml: String) throws -> InterfaceBuilderNode.XibDocument {
        let root = xmlParser.parseString(xml)
        guard let document: XMLIndexerProtocol = root.byKey("document") else {
            throw Error.invalidFormatFile
        }
        return try decodeValue(document)
    }

    public enum Error: Swift.Error {
        case invalidFormatFile
    }
}
