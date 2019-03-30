//
//  ViewAsDeviceRule.swift
//  IBLinterKit
//
//  Created by Shinichi Hosokawa on 2019/03/25.
//

import IBDecodable

private func deviceName(from deviceId: String) -> String {
    switch deviceId {
    case "retina3_5": return "iPhone 4s"
    case "retina4_0": return "iPhone SE"
    case "retina4_7": return "iPhone 8"
    case "retina5_5": return "iPhone 8 Plus"
    case "retina5_9": return "iPhone XS"
    case "retina6_1": return "iPhone XR"
    case "retina6_5": return "iPhone XS Max"
    default: return "Unknown device"
    }
}

extension Rules {
    fileprivate static func violation<T: InterfaceBuilderFile>(deviceIdToFit: String, file: T) -> [Violation] {
        guard let document = file.document as? InterfaceBuilderDocument,
            let deviceId = document.device?.id else {
            let message = "\"View as:\" should be \(deviceName(from: deviceIdToFit)) (\(deviceIdToFit)) explicitly"
            return [Violation(pathString: file.pathString, message: message, level: .warning)]
        }
        let message = "\"View as:\" should be \(deviceName(from: deviceIdToFit)) (\(deviceIdToFit)). Currently it is \(deviceName(from: deviceId)) (\(deviceId))."
        return deviceId == deviceIdToFit ? [] : [Violation(pathString: file.pathString, message: message, level: .warning)]
    }

    public struct ViewAsDeviceRule: Rule {
        public static var identifier: String = "view_as_device"

        public let deviceIdToFit: String
        public init(context: Context) {
            deviceIdToFit = context.config.viewAsDeviceRule?.deviceId ?? "retina4_7"
        }
        public func validate(storyboard: StoryboardFile) -> [Violation] {
            return Rules.violation(deviceIdToFit: deviceIdToFit, file: storyboard)
        }
        public func validate(xib: XibFile) -> [Violation] {
            return Rules.violation(deviceIdToFit: deviceIdToFit, file: xib)
        }
    }
}
