//
//  InterfaceBuilderNode.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/05.
//

public enum InterfaceBuilderNode {}

public extension InterfaceBuilderNode {

    public struct StoryboardDocument: XMLDecodable {
        public let type: String
        public let version: String
        public let toolsVersion: String
        public let targetRuntime: String
        public let propertyAccessControl: String?
        public let useAutolayout: Bool?
        public let useTraitCollections: Bool?
        public let useSafeAreas: Bool?
        public let colorMatched: Bool?
        public let initialViewController: String?
        public let device: Device?
        public let scenes: [Scene]?
        public let placeholders: [Placeholder]?

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.StoryboardDocument {
            return InterfaceBuilderNode.StoryboardDocument.init(
                type:                  try xml.attributeValue(of: "type"),
                version:               try xml.attributeValue(of: "version"),
                toolsVersion:          try xml.attributeValue(of: "toolsVersion"),
                targetRuntime:         try xml.attributeValue(of: "targetRuntime"),
                propertyAccessControl: xml.attributeValue(of: "propertyAccessControl"),
                useAutolayout:         xml.attributeValue(of: "useAutolayout"),
                useTraitCollections:   xml.attributeValue(of: "useTraitCollections"),
                useSafeAreas:          xml.attributeValue(of: "useSafeAreas"),
                colorMatched:          xml.attributeValue(of: "colorMatched"),
                initialViewController: xml.attributeValue(of: "initialViewController"),
                device:                xml.byKey("device").flatMap(decodeValue),
                scenes:                xml.byKey("scenes")?.byKey("scene")?.allElements.flatMap(decodeValue),
                placeholders:          xml.byKey("objects")?.byKey("placeholder")?.allElements.flatMap(decodeValue)
            )
        }
    }

    public struct XibDocument: XMLDecodable {
        public let type: String
        public let version: String
        public let toolsVersion: String
        public let targetRuntime: String
        public let propertyAccessControl: String?
        public let useAutolayout: Bool?
        public let useTraitCollections: Bool?
        public let useSafeAreas: Bool?
        public let colorMatched: Bool?
        public let device: Device?
        public let views: [View]?
        public let placeholders: [Placeholder]?

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.XibDocument {
            return InterfaceBuilderNode.XibDocument.init(
                type:                  try xml.attributeValue(of: "type"),
                version:               try xml.attributeValue(of: "version"),
                toolsVersion:          try xml.attributeValue(of: "toolsVersion"),
                targetRuntime:         try xml.attributeValue(of: "targetRuntime"),
                propertyAccessControl: xml.attributeValue(of: "propertyAccessControl"),
                useAutolayout:         xml.attributeValue(of: "useAutolayout"),
                useTraitCollections:   xml.attributeValue(of: "useTraitCollections"),
                useSafeAreas:          xml.attributeValue(of: "useSafeAreas"),
                colorMatched:          xml.attributeValue(of: "colorMatched"),
                device:                xml.byKey("device").flatMap(decodeValue),
                views:                 xml.byKey("objects")?.childrenNode.flatMap(decodeValue),
                placeholders:          xml.byKey("objects")?.byKey("placeholder")?.allElements.flatMap(decodeValue)
            )
        }
    }

    public struct Device: XMLDecodable {
        public let id: String
        public let orientation: String?
        public let adaptation: String?

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.Device {
            return Device.init(
                id:          try xml.attributeValue(of: "id"),
                orientation: xml.attributeValue(of: "orientation"),
                adaptation:  xml.byKey("adaptation")?.attributeValue(of: "id")
            )
        }
    }

    public struct Scene: XMLDecodable {
        public let id: String
        public let viewController: ViewController?

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.Scene {
            return Scene.init(
                id:             try xml.attributeValue(of: "sceneID"),
                viewController: xml.byKey("objects")?.childrenNode.first.flatMap(decodeValue)
            )
        }
    }

    public struct Placeholder: XMLDecodable {
        public let id: String
        public let placeholderIdentifier: String
        public let userLabel: String?
        public let sceneMemberID: String?
        public let customClass: String?

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.Placeholder {
            return Placeholder.init(
                id:                    try xml.attributeValue(of: "id"),
                placeholderIdentifier: try xml.attributeValue(of: "placeholderIdentifier"),
                userLabel:             xml.attributeValue(of: "userLabel"),
                sceneMemberID:         xml.attributeValue(of: "userLabel"),
                customClass:           xml.attributeValue(of: "customClass")
            )
        }
    }

    public struct ViewControllerLayoutGuide: XMLDecodable {
        public let id: String
        public let type: String

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.ViewControllerLayoutGuide {
            return try ViewControllerLayoutGuide.init(
                id: xml.attributeValue(of: "id"),
                type: xml.attributeValue(of: "type")
            )
        }
    }

    public struct LayoutGuide: XMLDecodable {
        public let key: String
        public let id: String

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.LayoutGuide {
            return try LayoutGuide.init(
                key: xml.attributeValue(of: "key"),
                id: xml.attributeValue(of: "id")
            )
        }
    }

    public enum Error: Swift.Error, CustomStringConvertible {
        case elementNotFound
        case unsupportedViewClass(String)
        case unsupportedViewControllerClass(String)
        case unsupportedConstraint(String)
        case unsupportedTableViewDataMode(String)
        case unsupportedColorSpace(String)
        case unsupportedConnectionType(String)

        public var description: String {
            switch self {
            case .elementNotFound:
                return "element not found"
            case .unsupportedViewClass(let name):
                return "unsupported view class '\(name)'"
            case .unsupportedViewControllerClass(let name):
                return "unsupported viewController class '\(name)'"
            case .unsupportedConstraint(let body):
                return "unsupported constraint type '\(body)'"
            case .unsupportedTableViewDataMode(let name):
                return "unsupported dataMode '\(name)'"
            case .unsupportedColorSpace(let colorSpace):
                return "unsupported color space '\(colorSpace)'"
            case .unsupportedConnectionType(let connectionType):
                return "unsupported connection type \(connectionType)"
            }
        }
    }
}
