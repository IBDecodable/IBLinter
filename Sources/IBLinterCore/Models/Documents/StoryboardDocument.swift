//
//  StoryboardDocument.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

// MARK: - StoryboardDocument

public struct StoryboardDocument: XMLDecodable, HasAutomaticCodingKeys {
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
    public let objects: [Placeholder]?

    enum ScenesCodingKeys: CodingKey { case scene }
    enum ObjectsCodingKeys: CodingKey { case placeholder }

    static func decode(_ xml: XMLIndexer) throws -> StoryboardDocument {
        let container = xml.container(keys: CodingKeys.self)
        let scencesContainer = container.nestedContainerIfPresent(of: .scenes, keys: ScenesCodingKeys.self)
        let objectsContainer = container.nestedContainerIfPresent(of: .objects, keys: ObjectsCodingKeys.self)
        return try StoryboardDocument.init(
            type:                  container.attribute(of: .type),
            version:               container.attribute(of: .version),
            toolsVersion:          container.attribute(of: .toolsVersion),
            targetRuntime:         container.attribute(of: .targetRuntime),
            propertyAccessControl: container.attributeIfPresent(of: .propertyAccessControl),
            useAutolayout:         container.attributeIfPresent(of: .useAutolayout),
            useTraitCollections:   container.attributeIfPresent(of: .useTraitCollections),
            useSafeAreas:          container.attributeIfPresent(of: .useSafeAreas),
            colorMatched:          container.attributeIfPresent(of: .colorMatched),
            initialViewController: container.attributeIfPresent(of: .initialViewController),
            device:                container.elementIfPresent(of: .device),
            scenes:                scencesContainer?.elementsIfPresent(of: .scene),
            objects:               objectsContainer?.elementsIfPresent(of: .placeholder)
        )
    }
}

// MARK: - Device

public struct Device: XMLDecodable, HasAutomaticCodingKeys {
    public let id: String
    public let orientation: String?
    public let adaptation: String?

    enum AdaptationCodingKeys: CodingKey { case id }

    static func decode(_ xml: XMLIndexer) throws -> Device {
        let container = xml.container(keys: CodingKeys.self)
        let adaptationContainer = container.nestedContainerIfPresent(of: .adaptation, keys: AdaptationCodingKeys.self)
        return try Device.init(
            id:          container.attribute(of: .id),
            orientation: container.attributeIfPresent(of: .orientation),
            adaptation:  adaptationContainer?.attributeIfPresent(of: .id)
        )
    }
}

// MARK: - Scene

public struct Scene: XMLDecodable, HasAutomaticCodingKeys {
    public let id: String
    public let viewController: AnyViewController?

    enum CodingKeys: String, CodingKey {
        case id = "sceneID"
        case viewController = "objects"
    }

    static func decode(_ xml: XMLIndexer) throws -> Scene {
        let container = xml.container(keys: CodingKeys.self)
        return try Scene.init(
            id:             container.attribute(of: .id),
            viewController: container.childrenIfPresent(of: .viewController)?.first
        )
    }
}

// MARK: - Placeholder

public struct Placeholder: XMLDecodable, HasAutomaticCodingKeys {
    public let id: String
    public let placeholderIdentifier: String
    public let userLabel: String?
    public let sceneMemberID: String?
    public let customClass: String?

    static func decode(_ xml: XMLIndexer) throws -> Placeholder {
        let container = xml.container(keys: CodingKeys.self)
        return try Placeholder.init(
            id:                    container.attribute(of: .id),
            placeholderIdentifier: container.attribute(of: .placeholderIdentifier),
            userLabel:             container.attributeIfPresent(of: .userLabel),
            sceneMemberID:         container.attributeIfPresent(of: .userLabel),
            customClass:           container.attributeIfPresent(of: .customClass)
        )
    }
}
