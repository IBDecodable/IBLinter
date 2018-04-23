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
    public let reporter: String

    enum CodingKeys: String, CodingKey {
        case disabledRules = "disabled_rules"
        case enabledRules = "enabled_rules"
        case excluded = "excluded"
        case reporter = "reporter"
    }

    public static let fileName = ".iblinter.yml"
    public static let `default` = Config.init()

    private init() {
        disabledRules = []
        enabledRules = []
        excluded = []
        reporter = "xcode"
    }

    init(disabledRules: [String], enabledRules: [String], excluded: [String], reporter: String) {
        self.disabledRules = disabledRules
        self.enabledRules = enabledRules
        self.excluded = excluded
        self.reporter = reporter
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        disabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .disabledRules).flatMap { $0 } ?? []
        enabledRules = try container.decodeIfPresent(Optional<[String]>.self, forKey: .enabledRules).flatMap { $0 } ?? []
        excluded = try container.decodeIfPresent(Optional<[String]>.self, forKey: .excluded).flatMap { $0 } ?? []
        reporter = try container.decodeIfPresent(Optional<String>.self, forKey: .reporter).flatMap { $0 } ?? "xcode"
    }

    public static func load(_ url: URL) throws -> Config {
        return try YAMLDecoder.init().decode(from: String.init(contentsOf: url))
    }

    public static func load(from configPath: String, fileName: String = fileName) throws -> Config {
        let url = URL.init(fileURLWithPath: configPath).appendingPathComponent(fileName)
        return try load(url)
    }
}
