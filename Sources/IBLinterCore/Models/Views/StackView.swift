//
//  StackView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct StackView: XMLDecodable, ViewProtocol, HasAutomaticCodingKeys {
    public let id: String
    public let elementClass: String = "UIStackView"

    public let alignment: String?
    public let autoresizingMask: AutoresizingMask?
    public let axis: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let misplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    enum ConstraintsCodingKeys: CodingKey { case constraint }

    static func decode(_ xml: XMLIndexer) throws -> StackView {
        let container = xml.container(for: self.self, keys: CodingKeys.self)
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        return try StackView.init(
            id:                                        container.attribute(of: .id),
            alignment:                                 container.attributeIfPresent(of: .alignment),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
            axis:                                      container.attributeIfPresent(of: .axis),
            clipsSubviews:                             container.attributeIfPresent(of: .clipsSubviews),
            constraints:                               constraintsContainer?.elementsIfPresent(of: .constraint),
            contentMode:                               container.attributeIfPresent(of: .contentMode),
            customClass:                               container.attributeIfPresent(of: .customClass),
            customModule:                              container.attributeIfPresent(of: .customModule),
            misplaced:                                 container.attributeIfPresent(of: .misplaced),
            opaque:                                    container.attributeIfPresent(of: .opaque),
            rect:                                      container.element(of: .rect),
            subviews:                                  container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints: container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                    container.attributeIfPresent(of: .userInteractionEnabled)
        )
    }
}
