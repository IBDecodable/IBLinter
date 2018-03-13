//
//  SegmentedControl.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct SegmentedControl: XMLDecodable, ViewProtocol, KeyDecodable {
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
    public let misplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let segmentControlStyle: String?
    public let segments: [Segment]?
    public let selectedSegmentIndex: Int?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct Segment: XMLDecodable, KeyDecodable {
        public let title: String

        static func decode(_ xml: XMLIndexer) throws -> SegmentedControl.Segment {
            let container = xml.container(keys: CodingKeys.self)
            return try Segment.init(title: container.attribute(of: .title))
        }
    }

    enum ConstraintsCodingKeys: CodingKey { case constraint }
    enum SegmentCodingKeys: CodingKey { case segment }

    static func decode(_ xml: XMLIndexer) throws -> SegmentedControl {
        let container = xml.container(keys: CodingKeys.self)
        let constraintsContainer = container.nestedContainerIfPresent(of: .constraints, keys: ConstraintsCodingKeys.self)
        let segmentsContainer = container.nestedContainerIfPresent(of: .segments, keys: SegmentCodingKeys.self)
        return try SegmentedControl.init(
            id:                                         container.attribute(of: .id),
            autoresizingMask:                           container.elementIfPresent(of: .autoresizingMask),
            clipsSubviews:                              container.attributeIfPresent(of: .clipsSubviews),
            constraints:                                constraintsContainer?.elements(of: .constraint),
            contentHorizontalAlignment:                 container.attributeIfPresent(of: .contentHorizontalAlignment),
            contentMode:                                container.attributeIfPresent(of: .contentMode),
            contentVerticalAlignment:                   container.attributeIfPresent(of: .contentVerticalAlignment),
            customClass:                                container.attributeIfPresent(of: .customClass),
            customModule:                               container.attributeIfPresent(of: .customModule),
            misplaced:                                  container.attributeIfPresent(of: .misplaced),
            opaque:                                     container.attributeIfPresent(of: .opaque),
            rect:                                       container.element(of: .rect),
            segmentControlStyle:                        container.attributeIfPresent(of: .segmentControlStyle),
            segments:                                   segmentsContainer?.elementsIfPresent(of: .segment),
            selectedSegmentIndex:                       container.attributeIfPresent(of: .selectedSegmentIndex),
            subviews:                                   container.childrenIfPresent(of: .subviews),
            translatesAutoresizingMaskIntoConstraints:  container.attributeIfPresent(of: .translatesAutoresizingMaskIntoConstraints),
            userInteractionEnabled:                     container.attributeIfPresent(of: .userInteractionEnabled)
        )
    }
}
