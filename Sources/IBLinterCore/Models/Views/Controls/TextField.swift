//
//  TextField.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

public struct TextField: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITextField"

    public let autoresizingMask: AutoresizingMask?
    public let borderStyle: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let fixedFrame: Bool?
    public let font: FontDescription?
    public let minimumFontSize: Float?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let textAlignment: String?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> TextField {
        return TextField.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            borderStyle:                               xml.attributeValue(of: "borderStyle"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            fixedFrame:                                xml.attributeValue(of: "fixedFrame"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            minimumFontSize:                           xml.attributeValue(of: "minimumFontSize"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            textAlignment:                             xml.attributeValue(of: "textAlignment"),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }

}
