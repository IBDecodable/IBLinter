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
    public let useBaseClassRule: [UseBaseClassConfig]
    public let viewAsDeviceRule: ViewAsDeviceConfig?
    public let reporter: String
    public let disableWhileBuildingForIB: Bool

    enum CodingKeys: String, CodingKey {
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
        case excluded = "excluded"
        case included = "included"
        case customModuleRule = "custom_module_rule"
        case useBaseClassRule = "use_base_class_rule"
        case viewAsDeviceRule = "view_as_device_rule"
        case reporter = "reporter"
        case disableWhileBuildingForIB = "disable_while_building_for_ib"
    }

    public static let fileName: String = ".iblinter.yml"
    public static let `default`: Config = Config.init()

    private init() {
        disabledRules = []
        enabledRules = []
        excluded = []
        included = []
        customModuleRule = []
        useBaseClassRule = []
        viewAsDeviceRule = nil
        reporter = "xcode"
        disableWhileBuildingForIB = true
    }

    init(disabledRules: [String] = [], enabledRules: [String] = [],
         excluded: [String] = [], included: [String] = [],
         customModuleRule: [CustomModuleConfig] = [],
         baseClassRule: [UseBaseClassConfig] = [],
         viewAsDeviceRule: ViewAsDeviceConfig? = nil,
         reporter: String = "xcode", disableWhileBuildingForIB: Bool = true) {
        self.disabledRules = disabledRules
        self.enabledRules = enabledRules
        self.excluded = excluded
        self.included = included
        self.customModuleRule = customModuleRule
        self.useBaseClassRule = baseClassRule
        self.viewAsDeviceRule = viewAsDeviceRule
        self.reporter = reporter
        self.disableWhileBuildingForIB = disableWhileBuildingForIB
    }

    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Config.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        disabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .disabledRules).flatMap { $0 } ?? []
        enabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .enabledRules).flatMap { $0 } ?? []
        excluded = try container.decodeIfPresent(Optional<[String]>.self, forKey: .excluded).flatMap { $0 } ?? []
        included = try container.decodeIfPresent(Optional<[String]>.self, forKey: .included).flatMap { $0 } ?? []
        customModuleRule = try container.decodeIfPresent(Optional<[CustomModuleConfig]>.self, forKey: .customModuleRule).flatMap { $0 } ?? []
        useBaseClassRule = try container.decodeIfPresent(Optional<[UseBaseClassConfig]>.self, forKey: .useBaseClassRule)?.flatMap { $0 } ?? []
        viewAsDeviceRule = try container.decodeIfPresent(Optional<ViewAsDeviceConfig>.self, forKey: .viewAsDeviceRule) ?? nil
        reporter = try container.decodeIfPresent(String.self, forKey: .reporter) ?? "xcode"
        disableWhileBuildingForIB = try container.decodeIfPresent(Bool.self, forKey: .disableWhileBuildingForIB) ?? true
    }

    public static func load(_ url: URL) throws -> Config {
        return try YAMLDecoder.init().decode(from: String.init(contentsOf: url))
    }

    public static func load(from configPath: URL, fileName: String = fileName) throws -> Config {
        let url: URL = configPath.appendingPathComponent(fileName)
        return try load(url)
    }
}
