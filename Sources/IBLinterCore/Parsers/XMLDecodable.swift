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

extension XMLAttributeDecodable {
    public func encode(to encoder: Encoder) throws { fatalError() }
}

protocol XMLDecodable {
    static func decode(_ xml: XMLIndexer) throws -> Self
}

protocol KeyDecodable: Encodable {
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) throws -> T {
    return try T.decode(xml)
}

func decodeValue<T: XMLDecodable>(_ xml: XMLIndexer) -> T? {
    return try? T.decode(xml)
}

extension XMLIndexer {
    func container<K>(keys: K.Type) -> XMLIndexerContainer<K> {
        return XMLIndexerContainer.init(indexer: self)
    }
}

class XMLIndexerContainer<K> where K: CodingKey {

    private let indexer: XMLIndexer

    fileprivate init(indexer: XMLIndexer) {
        self.indexer = indexer
    }

    func attribute<T>(of key: K) throws -> T where T: XMLAttributeDecodable {
        return try indexer.attributeValue(of: key.stringValue)
    }

    func attributeIfPresent<T>(of key: K) -> T? where T: XMLAttributeDecodable {
        return try? attribute(of: key)
    }

    func element<T>(of key: K) throws -> T where T: XMLDecodable {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return try decodeValue(nestedIndexer)
    }

    func elementIfPresent<T>(of key: K) -> T? where T: XMLDecodable {
        return try? element(of: key)
    }

    func elements<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return try nestedIndexer.all.map(decodeValue)
    }

    func elementsIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        return try? elements(of: key)
    }

    func children<T>(of key: K) throws -> [T] where T: XMLDecodable {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return try nestedIndexer.children.map(decodeValue)
    }

    func childrenIfPresent<T>(of key: K) -> [T]? where T: XMLDecodable {
        let nestedIndexer: XMLIndexer? = indexer.byKey(key.stringValue)
        return nestedIndexer?.children.flatMap(decodeValue)
    }

    func nestedContainer<A>(of key: K, keys: A.Type) throws -> XMLIndexerContainer<A> {
        let nestedIndexer: XMLIndexer = try indexer.byKey(key.stringValue)
        return XMLIndexerContainer<A>.init(indexer: nestedIndexer)
    }

    func nestedContainerIfPresent<A>(of key: K, keys: A.Type) -> XMLIndexerContainer<A>? {
        return try? nestedContainer(of: key, keys: keys)
    }

    func nestedContainers<A>(of key: K, keys: A.Type) throws -> [XMLIndexerContainer<A>] {
        let nestedIndexers: [XMLIndexer] = try indexer.byKey(key.stringValue).all
        return nestedIndexers.map(XMLIndexerContainer<A>.init)
    }
}
