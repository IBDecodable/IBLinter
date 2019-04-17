//
//  BaseClassConfig.swift
//  AEXML
//
//  Created by masamichi on 2019/03/11.
//

import Foundation

public struct UseBaseClassConfig: Codable {
    public let elementClass: String
    public let baseClasses: [String]

    enum CodingKeys: String, CodingKey {
        case elementClass = "element_class"
        case baseClasses = "base_classes"
    }

    init(elementClass: String, baseClasses: [String]) {
        self.elementClass = elementClass
        self.baseClasses = baseClasses
    }

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<UseBaseClassConfig.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        elementClass = try container.decode(String.self, forKey: .elementClass)
        baseClasses = try container.decodeIfPresent(Optional<[String]>.self, forKey: .baseClasses)?.flatMap { $0 } ?? []
    }
}
