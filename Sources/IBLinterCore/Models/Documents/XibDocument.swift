//
//  XibDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct XibDocument: XMLDecodable {
    public let type: String
    public let version: String
    public let toolsVersion: String
    public let targetRuntime: String
    public let propertyAccessControl: String?
    public let useAutolayout: Bool?
    public let useTraitCollections: Bool?
    public let useSafeAreas: Bool?
    public let colorMatched: Bool?
    public let device: Device?
    public let views: [AnyView]?
    public let placeholders: [Placeholder]?

    static func decode(_ xml: XMLIndexer) throws -> XibDocument {
        return XibDocument.init(
            type:                  try xml.attributeValue(of: "type"),
            version:               try xml.attributeValue(of: "version"),
            toolsVersion:          try xml.attributeValue(of: "toolsVersion"),
            targetRuntime:         try xml.attributeValue(of: "targetRuntime"),
            propertyAccessControl: xml.attributeValue(of: "propertyAccessControl"),
            useAutolayout:         xml.attributeValue(of: "useAutolayout"),
            useTraitCollections:   xml.attributeValue(of: "useTraitCollections"),
            useSafeAreas:          xml.attributeValue(of: "useSafeAreas"),
            colorMatched:          xml.attributeValue(of: "colorMatched"),
            device:                xml.byKey("device").flatMap(decodeValue),
            views:                 xml.byKey("objects")?.children.flatMap(decodeValue),
            placeholders:          xml.byKey("objects")?.byKey("placeholder")?.all.flatMap(decodeValue)
        )
    }
}
