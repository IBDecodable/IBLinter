//
//  CustomModuleConfig.swift
//  IBLinterKit
//
//  Created by FukagawaSatoru on 2018/7/3.
//

import Foundation
import Yams

public struct CustomModuleConfig: Codable {
    public let module: String
    public let included: [String]
    public let excluded: [String]

    public static let `default` = CustomModuleConfig.init()

    private init() {
        module = ""
        included = []
        excluded = []
    }

    init(module: String, included: [String], excluded: [String]) {
        self.module = module
        self.included = included
        self.excluded = excluded
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        module = try container.decodeIfPresent(Optional<String>.self, forKey: .module).flatMap { $0 } ?? ""
        included = try container.decodeIfPresent(Optional<[String]>.self, forKey: .included).flatMap { $0 } ?? []
        excluded = try container.decodeIfPresent(Optional<[String]>.self, forKey: .excluded).flatMap { $0 } ?? []
    }

}
