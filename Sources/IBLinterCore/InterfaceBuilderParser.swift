//
//  InterfaceBuilder.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/05.
//

import SWXMLHash

private let cocoaTouchKey = "com.apple.InterfaceBuilder3.CocoaTouch.XIB"
private let cocoaKey = "com.apple.InterfaceBuilder3.Cocoa.XIB"

public struct InterfaceBuilderParser {

    private let xmlParser: SWXMLHash

    public init() {
        xmlParser = SWXMLHash.config({_ in})
    }

    public func parseStoryboard(xml: String) throws -> StoryboardDocument {
        let root = xmlParser.parse(xml)
        guard let document: XMLIndexer = root.byKey("document") else {
            guard let archive: XMLIndexer = root.byKey("archive"),
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

    public func parseXib(xml: String) throws -> XibDocument {
        let root = xmlParser.parse(xml)
        guard let document: XMLIndexer = root.byKey("document") else {
            guard let archive: XMLIndexer = root.byKey("archive"),
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
