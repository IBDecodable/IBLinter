//
//  Toolbar.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Toolbar: XMLDecodable, ViewProtocol, KeyDecodable {
    public let id: String
    public let elementClass: String = "UIToolbar"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let items: [BarButtonItem]?
    public let misplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?


    public struct BarButtonItem: XMLDecodable, KeyDecodable {
        public let id: String
        public let style: String?
        public let systemItem: String?
        public let title: String?

        static func decode(_ xml: XMLIndexer) throws -> Toolbar.BarButtonItem {
            let container = xml.container(keys: CodingKeys.self)
            return try BarButtonItem.init(
                id:         container.attribute(of: .id),
                style:      container.attributeIfPresent(of: .style),
                systemItem: container.attributeIfPresent(of: .systemItem),
                title:      container.attributeIfPresent(of: .title)
            )
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum ItemsCodingKeys: CodingKey { case barButtonItem }

    static func decode(_ xml: XMLIndexer) throws -> Toolbar {
        let container = xml.container(keys: CodingKeys.self)
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let itemsContainer = container.nestedContainerIfPresent(of: .items, keys: ItemsCodingKeys.self)
        return try Toolbar.init(
            id:                                        container.attribute(of: .id),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            items:                                     itemsContainer?.elements(of: .barButtonItem),
            misplaced:                                 container.attributeIfPresent(of: .misplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.element(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled)
        )
    }
}
