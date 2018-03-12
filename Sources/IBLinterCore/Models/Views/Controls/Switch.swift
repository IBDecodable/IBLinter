//
//  Switch.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Switch: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UISwitch"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let horizontalHuggingPriority: Int?
    public let isMisplaced: Bool?
    public let on: Bool
    public let onTintColor: Color?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let verticalHuggingPriority: Int?

    static func decode(_ xml: XMLIndexer) throws -> Switch {
        return Switch.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            horizontalHuggingPriority:                 xml.attributeValue(of: "horizontalHuggingPriority"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            on:                                        try xml.attributeValue(of: "on"),
            onTintColor:                               xml.byKey("color").flatMap(decodeValue),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            verticalHuggingPriority:                   xml.attributeValue(of: "verticalHuggingPriority")
        )
    }
}
