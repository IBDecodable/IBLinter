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
    public let customModuleRule: [CustomModuleConfig]
    public let reporter: String

    enum CodingKeys: String, CodingKey {
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
        case excluded = "excluded"
        case customModuleRule = "custom_module_rule"
        case reporter = "reporter"
    }

    public static let `default` = Config.init()

    private init() {
        disabledRules = []
        enabledRules = []
        excluded = []
        customModuleRule = []
        reporter = "xcode"
    }

    init(disabledRules: [String], enabledRules: [String], excluded: [String], customModuleRule: [CustomModuleConfig], reporter: String) {
        self.disabledRules = disabledRules
        self.enabledRules = enabledRules
        self.excluded = excluded
        self.customModuleRule = customModuleRule
        self.reporter = reporter
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        disabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .disabledRules).flatMap { $0 } ?? []
        enabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .enabledRules).flatMap { $0 } ?? []
        excluded = try container.decodeIfPresent(Optional<[String]>.self, forKey: .excluded).flatMap { $0 } ?? []
        customModuleRule = try container.decodeIfPresent(Optional<[CustomModuleConfig]>.self, forKey: .customModuleRule).flatMap { $0 } ?? []
        reporter = try container.decodeIfPresent(Optional<String>.self, forKey: .reporter).flatMap { $0 } ?? "xcode"
    }

    public static func load(from url: URL) throws -> Config {
        return try YAMLDecoder.init().decode(from: String.init(contentsOf: url))
    }
}
