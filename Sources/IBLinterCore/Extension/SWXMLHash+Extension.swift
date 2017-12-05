//
//  SWXMLHash+Extension.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/14.
//

import SWXMLHash
import Foundation

extension SWXMLHash: XMLParserProtocol {
    public func parseString(_ xml: String) -> XMLIndexerProtocol {
        return parse(xml)
    }
}

extension SWXMLHash.XMLElement: XMLElementProtocol {}
extension XMLAttribute: XMLAttributeProtocol {}
extension XMLIndexer: XMLIndexerProtocol {

    public var childrenNode: [XMLIndexerProtocol] {
        return children
    }

    public func attributeValue<T>(of attr: String) -> T? where T : XMLAttributeDecodable {
        return try? attributeValue(of: attr)
    }

    public func attributeValue<T>(of attr: String) throws -> T where T : XMLAttributeDecodable {
        switch self {
        case .element(let element):
            guard let attr = element.attribute(by: attr) else { throw XMLDeserializationError.nodeHasNoValue }
            return try T.decode(attr)
        default: throw XMLDeserializationError.implementationIsMissing(method: "attributeValue for stream case")
        }
    }

    public func byKey(_ key: String) throws -> XMLIndexerProtocol {
        return try byKey(key) as XMLIndexer
    }

    public func byKey(_ key: String) -> XMLIndexerProtocol? {
        return try? byKey(key)
    }

    public var elementNode: XMLElementProtocol? {
        return element
    }

    public var allElements: [XMLIndexerProtocol] {
        return all
    }
}

func convert(x: XMLAttributeProtocol) -> XMLAttribute {
    return x as! XMLAttribute
}

extension XMLAttributeDeserializable where Self: XMLAttributeDecodable {
    public static func decode(_ attribute: XMLAttributeProtocol) throws -> Self {
        return try deserialize(convert(x: attribute))
    }
}

extension String: XMLAttributeDecodable {}
extension Int: XMLAttributeDecodable {}
extension Float: XMLAttributeDecodable {}
extension Bool: XMLAttributeDecodable {}
