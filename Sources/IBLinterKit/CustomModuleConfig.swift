//
//  Config.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/13.
//

import Foundation
import Yams

public struct CustomModuleConfig: Codable {
    public let module: String
    public let classes: [String]

    enum CodingKeys: String, CodingKey {
        case module = "module"
        case classes = "classes"
    }

    public static let `default` = CustomModuleConfig.init()

    private init() {
        module = ""
        classes = []
    }

    init(module: String, classes: [String]) {
        self.module = module
        self.classes = classes
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        module = try container.decodeIfPresent(Optional<String>.self, forKey: .module).flatMap { $0 } ?? ""
        classes = try container.decodeIfPresent(Optional<[String]>.self, forKey: .classes).flatMap { $0 } ?? []
    }

}
