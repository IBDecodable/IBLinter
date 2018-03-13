//
//  TextField.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

public struct TextField: XMLDecodable, ViewProtocol, KeyDecodable {
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
    public let fontDescription: FontDescription?
    public let minimumFontSize: Float?
    public let misplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let textAlignment: String?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    enum ConstraintsCodingKeys: CodingKey { case constraint }

    static func decode(_ xml: XMLIndexer) throws -> TextField {
        let container = xml.container(keys: CodingKeys.self)
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        return try TextField.init(
            id:                                        container.attribute(of: .id),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            borderStyle:                               container.attributeIfPresent(of: .borderStyle),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentHorizontalAlignment:                container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                  container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            fixedFrame:                                container.attributeIfPresent(of: .fixedFrame),
            fontDescription:                           container.elementIfPresent(of: .fontDescription),
            minimumFontSize:                           container.attributeIfPresent(of: .minimumFontSize),
            misplaced:                                 container.attributeIfPresent(of: .misplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.element(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            textAlignment:                             container.attributeIfPresent(of: .textAlignment),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled)
        )
    }

}
