//
//  SegmentedControl.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct SegmentedControl: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UISegmentedControl"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let segmentControlStyle: String?
    public let segments: [Segment]
    public let selectedSegmentIndex: Int?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct Segment: XMLDecodable {
        public let title: String

        static func decode(_ xml: XMLIndexer) throws -> SegmentedControl.Segment {
            return try Segment.init(title: xml.attributeValue(of: "title"))
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> SegmentedControl {
        return SegmentedControl.init(
            id:                                         try xml.attributeValue(of: "id"),
            autoresizingMask:                           xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                              xml.attributeValue(of: "clipsSubviews"),
            constraints:                                xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentHorizontalAlignment:                 xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                                xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                   xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                                xml.attributeValue(of: "customClass"),
            customModule:                               xml.attributeValue(of: "customModule"),
            isMisplaced:                                xml.attributeValue(of: "misplaced"),
            opaque:                                     xml.attributeValue(of: "opaque"),
            rect:                                       try decodeValue(xml.byKey("rect")),
            segmentControlStyle:                        xml.attributeValue(of: "segmentControlStyle"),
            segments:                                   try xml.byKey("segments").byKey("segment").all.map(decodeValue),
            selectedSegmentIndex:                       xml.attributeValue(of: "selectedSegmentIndex"),
            subviews:                                   xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints:  xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                     xml.attributeValue(of: "userInteractionEnabled")
        )
    }

}
