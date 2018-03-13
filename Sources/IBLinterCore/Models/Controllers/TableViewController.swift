//
//  TableViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct TableViewController: XMLDecodable, ViewControllerProtocol, HasAutomaticCodingKeys {
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public let storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let tableView: TableView?
    public var rootView: ViewProtocol? { return tableView }

    enum LayoutGuidesCodingKeys: CodingKey { case viewControllerLayoutGuide }

    static func decode(_ xml: XMLIndexer) throws -> TableViewController {
        let container = xml.container(for: self.self, keys: CodingKeys.self)
        let layoutGuidesContainer = container.nestedContainerIfPresent(of: .layoutGuides, keys: LayoutGuidesCodingKeys.self)
        return try TableViewController.init(
            id:                   container.attribute(of: .id),
            customClass:          container.attribute(of: .customClass),
            customModule:         container.attribute(of: .customModule),
            customModuleProvider: container.attribute(of: .customModuleProvider),
            storyboardIdentifier: container.attribute(of: .storyboardIdentifier),
            layoutGuides:         layoutGuidesContainer?.elements(of: .viewControllerLayoutGuide),
            tableView:            container.element(of: .tableView)
        )
    }
}
