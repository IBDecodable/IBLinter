//
//  UseTraitCollectionsConfig.swift
//  IBLinterKit
//
//  Created by Blazej SLEBODA on 13/09/2020
//

import Foundation

public struct UseTraitCollectionsConfig: Codable {
    public let enabled: Bool

    enum CodingKeys: String, CodingKey {
        case enabled
    }

    init(enabled: Bool) {
        self.enabled = enabled
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        enabled = try container.decode(Bool.self, forKey: .enabled)
    }
}
