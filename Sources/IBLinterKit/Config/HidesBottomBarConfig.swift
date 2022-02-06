//
//  HidesBottomBarConfig.swift
//  IBLinterKit
//
//  Created by ykkd on 2022/02/06.
//

import Foundation

public struct HidesBottomBarConfig: Codable {
    public let excludedViewControllers: [String]

    public static let `default` = HidesBottomBarConfig.init()

    private init() {
        excludedViewControllers = []
    }

    init(excludedViewControllers: [String]) {
        self.excludedViewControllers = excludedViewControllers
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        excludedViewControllers = try container.decodeIfPresent(Optional<[String]>.self, forKey: .excludedViewControllers).flatMap { $0 } ?? []
    }
}

extension HidesBottomBarConfig {
    
    enum CodingKeys: String, CodingKey {
        case excludedViewControllers = "excluded_view_controllers"
    }
}
