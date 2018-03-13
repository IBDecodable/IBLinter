//
//  Picker.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct PickerView: XMLDecodable, ViewProtocol, KeyDecodable {
    public let id: String
    public let elementClass: String = "UIPickerView"

    public let autoresizingMask: AutoresizingMask?
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

    static func decode(_ xml: XMLIndexer) throws -> PickerView {
        let container = xml.container(keys: CodingKeys.self)
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        return try PickerView.init(
            id:                                        container.attribute(of: .id),
            autoresizingMask:                          container.elementIfPresent(of: .autoresizingMask),
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
