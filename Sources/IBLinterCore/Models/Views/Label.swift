//
//  Label.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Label: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UILabel"

    public let adjustsFontSizeToFit: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let baselineAdjustment: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let horizontalHuggingPriority: Int?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let text: String
    public let textAlignment: String?
    public let textColor: Color?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let verticalHuggingPriority: Int?


    static func decode(_ xml: XMLIndexer) throws -> Label {
        return Label.init(
            id:                                        try xml.attributeValue(of: "id"),
            adjustsFontSizeToFit:                      xml.attributeValue(of: "adjustsFontSizeToFit"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            baselineAdjustment:                        xml.attributeValue(of: "baselineAdjustment"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            horizontalHuggingPriority:                 xml.attributeValue(of: "horizontalHuggingPriority"),
            lineBreakMode:                             xml.attributeValue(of: "lineBreakMode"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            text:                                      try xml.attributeValue(of: "text"),
            textAlignment:                             xml.attributeValue(of: "textAlignment"),
            textColor:                                 xml.byKey("color").flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            verticalHuggingPriority:                   xml.attributeValue(of: "verticalHuggingPriority")
        )
    }

}

// MARK: - FontDescription

public struct FontDescription: XMLDecodable {
    public let type: String
    public let pointSize: Float
    public let weight: String?

    static func decode(_ xml: XMLIndexer) throws -> FontDescription {
        return FontDescription.init(
            type:      try xml.attributeValue(of: "type"),
            pointSize: try xml.attributeValue(of: "pointSize"),
            weight:    xml.attributeValue(of: "weight")
        )
    }
}
