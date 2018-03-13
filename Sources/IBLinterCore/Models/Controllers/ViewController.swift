//
//  ViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct ViewController: XMLDecodable, ViewControllerProtocol, HasAutomaticCodingKeys {

    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let view: View?
    public var rootView: ViewProtocol? { return view }

    enum LayoutGuidesCodingKeys: CodingKey { case viewControllerLayoutGuide }

    static func decode(_ xml: XMLIndexer) throws -> ViewController {
        let container = xml.container(for: self.self, keys: CodingKeys.self)
        let layoutGuidesContainer = container.nestedContainerIfPresent(of: .layoutGuides, keys: LayoutGuidesCodingKeys.self)
        return try ViewController.init(
            id:                   container.attribute(of: .id),
            customClass:          container.attributeIfPresent(of: .customClass),
            customModule:         container.attributeIfPresent(of: .customModule),
            customModuleProvider: container.attributeIfPresent(of: .customModuleProvider),
            storyboardIdentifier: container.attributeIfPresent(of: .storyboardIdentifier),
            layoutGuides:         layoutGuidesContainer?.elements(of: .viewControllerLayoutGuide),
            view:                 container.element(of: .view)
        )
    }
}
