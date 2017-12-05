//
//  XMLParser.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/10.
//

public protocol XMLParserProtocol {
    func parseString(_ xml: String) -> XMLIndexerProtocol
}

public protocol XMLElementProtocol {
    var name: String { get }
}

public protocol XMLIndexerProtocol {
    var allElements: [XMLIndexerProtocol] { get }
    var elementNode: XMLElementProtocol? { get }
    var childrenNode: [XMLIndexerProtocol] { get }
    func byKey(_ key: String) throws -> XMLIndexerProtocol
    func byKey(_ key: String) -> XMLIndexerProtocol?
    func attributeValue<T: XMLAttributeDecodable>(of attr: String) throws -> T
    func attributeValue<T: XMLAttributeDecodable>(of attr: String) -> T?
}

public protocol XMLAttributeProtocol {
    var name: String { get }
    var text: String { get }
}

public protocol XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttributeProtocol) throws -> Self
}


