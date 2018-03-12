//
//  XMLDecodable.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/10.
//

import SWXMLHash
import Foundation

protocol XMLAttributeDecodable {
    static func decode(_ attribute: XMLAttribute) throws -> Self
}

protocol XMLDecodable {

    static func decode(_ xml: XMLIndexer) throws -> Self
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) throws -> T {
    return try T.decode(xml)
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) -> T? {
    return try? T.decode(xml)
}
