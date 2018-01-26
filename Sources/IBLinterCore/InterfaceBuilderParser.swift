//
//  InterfaceBuilder.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/05.
//

private let cocoaTouchKey = "com.apple.InterfaceBuilder3.CocoaTouch.XIB"
private let cocoaKey = "com.apple.InterfaceBuilder3.Cocoa.XIB"

public struct InterfaceBuilderParser {

    private let xmlParser: XMLParserProtocol

    public init(with parser: XMLParserProtocol) {
        xmlParser = parser
    }

    public func parseStoryboard(xml: String) throws -> InterfaceBuilderNode.StoryboardDocument {
        let root = xmlParser.parseString(xml)
        guard let document: XMLIndexerProtocol = root.byKey("document") else {
            guard let archive: XMLIndexerProtocol = root.byKey("archive"),
                let type: String = try? archive.attributeValue(of: "type") else {
                throw Error.invalidFormatFile
            }

            switch type {
            case cocoaTouchKey:
                throw Error.legacyFormat
            case cocoaKey:
                throw Error.macFormat
            default:
                throw Error.invalidFormatFile
            }
        }
        return try decodeValue(document)
    }

    public func parseXib(xml: String) throws -> InterfaceBuilderNode.XibDocument {
        let root = xmlParser.parseString(xml)
        guard let document: XMLIndexerProtocol = root.byKey("document") else {
            guard let archive: XMLIndexerProtocol = root.byKey("archive"),
                let type: String = try? archive.attributeValue(of: "type") else {
                    throw Error.invalidFormatFile
            }

            switch type {
            case cocoaTouchKey:
                throw Error.legacyFormat
            case cocoaKey:
                throw Error.macFormat
            default:
                throw Error.invalidFormatFile
            }
        }
        return try decodeValue(document)
    }

    public enum Error: Swift.Error {
        case invalidFormatFile
        case legacyFormat
        case macFormat
    }
}
