//
//  TableView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - TableView

public struct TableView: XMLDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UITableView"

    public let alwaysBounceVertical: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let dataMode: DataMode?
    public let estimatedRowHeight: Float?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let rowHeight: Float?
    public let sectionFooterHeight: Float?
    public let sectionHeaderHeight: Float?
    public let separatorStyle: String?
    public let style: String?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public enum DataMode: XMLAttributeDecodable {
        case `static`, prototypes

        static func decode(_ attribute: XMLAttribute) throws -> TableView.DataMode {
            switch attribute.text {
            case "static":     return .static
            case "prototypes": return .prototypes
            default:
                throw IBError.unsupportedTableViewDataMode(attribute.text)
            }
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> TableView {
        return TableView.init(
            id:                                        try xml.attributeValue(of: "id"),
            alwaysBounceVertical:                      xml.attributeValue(of: "alwaysBounceVertical"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            dataMode:                                  xml.attributeValue(of: "dataMode"),
            estimatedRowHeight:                        xml.attributeValue(of: "estimatedRowHeight"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            rowHeight:                                 xml.attributeValue(of: "rowHeight"),
            sectionFooterHeight:                       xml.attributeValue(of: "sectionFooterHeight"),
            sectionHeaderHeight:                       xml.attributeValue(of: "sectionHeaderHeight"),
            separatorStyle:                            xml.attributeValue(of: "separatorStyle"),
            style:                                     xml.attributeValue(of: "style"),
            subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - TableViewCell

public struct TableViewCell: XMLDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UITableView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: TableViewContentView
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    private let _subviews: [AnyView]?
    public var subviews: [AnyView]? {
        return (_subviews ?? []) + [AnyView(contentView)]
    }
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct TableViewContentView: XMLDecodable, ViewProtocol {
        public let id: String
        public let elementClass: String = "UITableViewContentView"

        public let autoresizingMask: AutoresizingMask?
        public let clipsSubviews: Bool?
        public let constraints: [Constraint]?
        public let contentMode: String?
        public let customClass: String?
        public let customModule: String?
        public let isMisplaced: Bool?
        public let opaque: Bool?
        public let rect: Rect
        public let subviews: [AnyView]?
        public let translatesAutoresizingMaskIntoConstraints: Bool?
        public let userInteractionEnabled: Bool?

        static func decode(_ xml: XMLIndexer) throws -> TableViewCell.TableViewContentView {
            return TableViewContentView.init(
                id:                                        try xml.attributeValue(of: "id"),
                autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
                contentMode:                               xml.attributeValue(of: "contentMode"),
                customClass:                               xml.attributeValue(of: "customClass"),
                customModule:                              xml.attributeValue(of: "customModule"),
                isMisplaced:                               xml.attributeValue(of: "misplaced"),
                opaque:                                    xml.attributeValue(of: "opaque"),
                rect:                                      try decodeValue(xml.byKey("rect")),
                subviews:                                  xml.byKey("subviews")?.children.flatMap(decodeValue),
                translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> TableViewCell {
        return TableViewCell.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(decodeValue),
            contentView:                               try decodeValue(xml.byKey("tableViewCellContentView")),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            _subviews:                                 xml.byKey("subviews")?.children.flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}
