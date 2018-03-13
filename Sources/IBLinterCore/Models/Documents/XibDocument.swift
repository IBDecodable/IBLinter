//
//  XibDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct XibDocument: XMLDecodable, HasAutomaticCodingKeys {
    public let type: String
    public let version: String
    public let toolsVersion: String
    public let targetRuntime: String
    public let propertyAccessControl: String?
    public let useAutolayout: Bool?
    public let useTraitCollections: Bool?
    public let useSafeAreas: Bool?
    public let colorMatched: Bool?
    public let device: Device?
    public var views: [AnyView]? { return objects?.flatMap { $0.view } }
    public var placeholders: [Placeholder]? { return objects?.flatMap { $0.placeholder } }
    let objects: [Object]?

    enum Object: XMLDecodable, HasAutomaticCodingKeys {
        case placeholder(Placeholder)
        case view(AnyView)

        var placeholder: Placeholder? {
            switch self {
            case .placeholder(let placeholder): return placeholder
            case .view: return nil
            }
        }

        var view: AnyView? {
            switch self {
            case .placeholder: return nil
            case .view(let view): return view
            }
        }
        static func decode(_ xml: XMLIndexer) throws -> XibDocument.Object {
            guard let elementName = xml.element?.name else {
                throw IBError.elementNotFound
            }
            switch elementName {
            case "placeholder": return try .placeholder(decodeValue(xml))
            default: return try .view(decodeValue(xml))
            }
        }

        func encode(to encoder: Encoder) throws { fatalError() }
    }

    static func decode(_ xml: XMLIndexer) throws -> XibDocument {
        let container = xml.container(for: self.self, keys: CodingKeys.self)
        return try XibDocument.init(
            type:                  container.attribute(of: .type),
            version:               container.attribute(of: .version),
            toolsVersion:          container.attribute(of: .toolsVersion),
            targetRuntime:         container.attribute(of: .targetRuntime),
            propertyAccessControl: container.attributeIfPresent(of: .propertyAccessControl),
            useAutolayout:         container.attributeIfPresent(of: .useAutolayout),
            useTraitCollections:   container.attributeIfPresent(of: .useTraitCollections),
            useSafeAreas:          container.attributeIfPresent(of: .useSafeAreas),
            colorMatched:          container.attributeIfPresent(of: .colorMatched),
            device:                container.elementIfPresent(of: .device),
            objects:               container.childrenIfPresent(of: .objects)
        )
    }
}
