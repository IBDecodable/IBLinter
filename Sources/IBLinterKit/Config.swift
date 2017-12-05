//
//  Config.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Foundation
import Yams

public struct Config: Codable {
    public let disabledRules: [String]
    public let enabledRules: [String]
    public let excluded: [String]

    enum CodingKeys: String, CodingKey {
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
        case excluded = "excluded"
    }

    public static let fileName = ".iblinter.yml"
    public static let `default` = Config.init()

    private init() {
        disabledRules = []
        enabledRules = []
        excluded = []
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        disabledRules = try container.decodeIfPresent([String].self, forKey: .disabledRules) ?? []
        enabledRules = try container.decodeIfPresent([String].self, forKey: .enabledRules) ?? []
        excluded = try container.decodeIfPresent([String].self, forKey: .excluded) ?? []
    }

    public static func load(from configPath: String) throws -> Config {
        let path = URL.init(fileURLWithPath: configPath).appendingPathComponent(fileName)
        return try YAMLDecoder.init().decode(from: String.init(contentsOf: path))
    }
}
