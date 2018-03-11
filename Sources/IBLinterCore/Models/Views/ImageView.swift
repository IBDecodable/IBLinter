//
//  ImageView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct ImageView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIImageView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let image: String
    public let insetsLayoutMarginsFromSafeArea: Bool?
    public let isMisplaced: Bool?
    public let multipleTouchEnabled: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> ImageView {
        return ImageView.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            image:                                     try xml.attributeValue(of: "image"),
            insetsLayoutMarginsFromSafeArea:           xml.attributeValue(of: "insetsLayoutMarginsFromSafeArea"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            multipleTouchEnabled:                      xml.attributeValue(of: "multipleTouchEnabled"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}
