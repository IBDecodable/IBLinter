//
//  TextView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct TextView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITextView"

    public let autoresizingMask: AutoresizingMask?
    public let bounces: Bool?
    public let bouncesZoom: Bool?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let scrollEnabled: Bool?
    public let showsHorizontalScrollIndicator: Bool?
    public let showsVerticalScrollIndicator: Bool?
    public let subviews: [AnyView]?
    public let text: String
    public let textAlignment: String?
    public let textColor: Color?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> TextView {
        return TextView.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            bounces:                                   xml.attributeValue(of: "bounces"),
            bouncesZoom:                               xml.attributeValue(of: "bouncesZoom"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            scrollEnabled:                             xml.attributeValue(of: "scrollEnabled"),
            showsHorizontalScrollIndicator:            xml.attributeValue(of: "showsHorizontalScrollIndicator"),
            showsVerticalScrollIndicator:              xml.attributeValue(of: "showsVerticalScrollIndicator"),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            text:                                      try xml.attributeValue(of: "text"),
            textAlignment:                             xml.attributeValue(of: "textAlignment"),
            textColor:                                 xml.byKey("color").flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}
