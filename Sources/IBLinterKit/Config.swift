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
    public let included: [String]
    public let customModuleRule: [CustomModuleConfig]
    public let baseClassRule: [UseBaseClassConfig]
    public let reporter: String

    enum CodingKeys: String, CodingKey {
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
        case excluded = "excluded"
        case included = "included"
        case customModuleRule = "custom_module_rule"
        case baseClassRule = "use_base_class_rule"
        case reporter = "reporter"
    }

    public static let fileName = ".iblinter.yml"
    public static let `default` = Config.init()

    private init() {
        disabledRules = []
        enabledRules = []
        excluded = []
        included = []
        customModuleRule = []
        baseClassRule = []
        reporter = "xcode"
    }

    init(disabledRules: [String], enabledRules: [String], excluded: [String], included: [String], customModuleRule: [CustomModuleConfig], baseClassRule: [UseBaseClassConfig], reporter: String) {
        self.disabledRules = disabledRules
        self.enabledRules = enabledRules
        self.excluded = excluded
        self.included = included
        self.customModuleRule = customModuleRule
        self.baseClassRule = baseClassRule
        self.reporter = reporter
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        disabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .disabledRules).flatMap { $0 } ?? []
        enabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .enabledRules).flatMap { $0 } ?? []
        excluded = try container.decodeIfPresent(Optional<[String]>.self, forKey: .excluded).flatMap { $0 } ?? []
        included = try container.decodeIfPresent(Optional<[String]>.self, forKey: .included).flatMap { $0 } ?? []
        customModuleRule = try container.decodeIfPresent(Optional<[CustomModuleConfig]>.self, forKey: .customModuleRule).flatMap { $0 } ?? []
        baseClassRule = try container.decodeIfPresent(Optional<[UseBaseClassConfig]>.self, forKey: .baseClassRule)?.flatMap { $0 } ?? []
        reporter = try container.decodeIfPresent(Optional<String>.self, forKey: .reporter).flatMap { $0 } ?? "xcode"
    }

    public static func load(_ url: URL) throws -> Config {
        return try YAMLDecoder.init().decode(from: String.init(contentsOf: url))
    }

    public static func load(from configPath: URL, fileName: String = fileName) throws -> Config {
        let url = configPath.appendingPathComponent(fileName)
        return try load(url)
    }
}
