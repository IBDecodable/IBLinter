//
//  Button.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Button: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIButton"

    public let autoresizingMask: AutoresizingMask?
    public let buttonType: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let textColor: TextColor
    public let title: Title
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct Title: XMLDecodable {
        public let disabled: String?
        public let highlighted: String?
        public let normal: String?
        public let selected: String?

        static func decode(_ xml: XMLIndexer) throws -> Button.Title {
            let allState = try xml.byKey("state").all

            func title(for key: String) -> String? {
                guard let stateElement = try? allState.first(where: { try $0.attributeValue(of: "key") == key }) else { return nil }
                return stateElement.flatMap { try? $0.attributeValue(of: "title") }
            }

            return Title.init(
                disabled: title(for: "disabled"),
                highlighted: title(for: "highlighted"),
                normal: title(for: "normal"),
                selected: title(for: "selected")
            )
        }
    }

    public struct TextColor: XMLDecodable {
        public let normal: Color?
        public let disabled: Color?
        public let selected: Color?
        public let highlighted: Color?

        static func decode(_ xml: XMLIndexer) throws -> Button.TextColor {
            let allState = try xml.byKey("state").all

            func color(for key: String) -> Color? {
                guard let colorElement = try? allState.first(where: { try $0.attributeValue(of: "key") == key })?.byKey("color") else { return nil }
                return colorElement.flatMap { try? Color.decode($0) }
            }
            return TextColor.init(
                normal: color(for: "normal"),
                disabled: color(for: "disabled"),
                selected: color(for: "selected"),
                highlighted: color(for: "highlighted")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Button {
        return Button.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            buttonType:                                xml.attributeValue(of: "buttonType"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            lineBreakMode:                             xml.attributeValue(of: "lineBreakMode"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            textColor:                                 try decodeValue(xml),
            title:                                     try decodeValue(xml),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}
