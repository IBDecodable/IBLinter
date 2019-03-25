//
//  ViewAsDeviceConfig.swift
//
//  Created by shosokawa on 2019/03/26.
//

import Foundation

public struct ViewAsDeviceConfig: Codable {
    public let deviceId: String

    enum CodingKeys: String, CodingKey {
        case deviceId = "device_id"
    }

    init(deviceId: String) {
        self.deviceId = deviceId
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        deviceId = try container.decode(String.self, forKey: .deviceId)
    }
}
