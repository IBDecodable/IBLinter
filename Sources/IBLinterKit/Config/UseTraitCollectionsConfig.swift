//
//  UseTraitCollectionsConfig.swift
//  IBLinterKit
//
//  Created by Blazej SLEBODA on 13/09/2020
//

import Foundation

public struct UseTraitCollectionsConfig: Codable {
    public let useTraitCollections: Bool

    enum CodingKeys: String, CodingKey {
        case useTraitCollections = "use_trait_collections"
    }

    init(useTraitCollections: Bool) {
        self.useTraitCollections = useTraitCollections
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        useTraitCollections = try container.decode(Bool.self, forKey: .useTraitCollections)
    }
}
