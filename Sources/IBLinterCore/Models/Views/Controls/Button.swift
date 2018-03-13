//
//  Button.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct Button: XMLDecodable, ViewProtocol, HasAutomaticCodingKeys {
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
    public let states: [State]
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct State: XMLDecodable, HasAutomaticCodingKeys {
        public let key: String
        public let title: String
        public let color: Color?

        static func decode(_ xml: XMLIndexer) throws -> Button.State {
            let container = xml.container(for: self.self, keys: CodingKeys.self)
            return try State.init(
                key: container.attribute(of: .key),
                title: container.attribute(of: .title),
                color: container.elementIfPresent(of: .color)
            )
        }
    }

    enum CodingKeys: String, CodingKey {
         case id
         case elementClass
         case autoresizingMask
         case buttonType
         case clipsSubviews
         case constraints
         case contentHorizontalAlignment
         case contentMode
         case contentVerticalAlignment
         case customClass
         case customModule
         case font = "fontDescription"
         case lineBreakMode
         case isMisplaced = "misplaced"
         case opaque
         case rect
         case subviews
         case states = "state"
         case translatesAutoresizingMaskIntoConstraints
         case userInteractionEnabled
    }

    enum NestedCodingKeys: CodingKey {
        case constraint
    }

    static func decode(_ xml: XMLIndexer) throws -> Button {
        let container = xml.container(for: self.self, keys: CodingKeys.self)
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: NestedCodingKeys.self)
        return try Button.init(
            id:                                        container.attribute(of: .id),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            buttonType:                                container.attributeIfPresent(of: .buttonType),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elements(of: .constraint),
            contentHorizontalAlignment:                container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                  container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customClass),
            font:                                      container.elementIfPresent(of: .font),
            lineBreakMode:                             container.attributeIfPresent(of: .lineBreakMode),
            isMisplaced:                               container.attributeIfPresent(of: .isMisplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.element(of: .rect),
            subviews:                                  container.elementsIfPresent(of: .subviews),
            states:                                    container.elements(of: .states),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled)
        )
    }
}
