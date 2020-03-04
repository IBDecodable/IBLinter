//
//  File.swift
//  
//
//  Created by Mark Fernandez on 2/19/20.
//

import Foundation

public struct UseColorConfig: Codable {
    public let allowedColors: [String]

    enum CodingKeys: String, CodingKey {
        case allowedColors = "allowed_colors"
    }

    init(allowedColors: [String]) {
        self.allowedColors = allowedColors
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        allowedColors = try container.decodeIfPresent(Optional<[String]>.self, forKey: .allowedColors)?.flatMap { $0 } ?? []
    }
}
