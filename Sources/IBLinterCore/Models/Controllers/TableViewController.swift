//
//  TableViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public struct TableViewController: XMLDecodable, ViewControllerProtocol {
    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let tableView: TableView?
    public var rootView: ViewProtocol? { return tableView }

    static func decode(_ xml: XMLIndexer) throws -> TableViewController {
        return TableViewController.init(
            id:                   try xml.attributeValue(of: "id"),
            customClass:          xml.attributeValue(of: "customClass"),
            customModule:         xml.attributeValue(of: "customModule"),
            customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
            storyboardIdentifier: xml.attributeValue(of: "storyboardIdentifier"),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            tableView:            xml.byKey("tableView").flatMap(decodeValue)
        )
    }
}
