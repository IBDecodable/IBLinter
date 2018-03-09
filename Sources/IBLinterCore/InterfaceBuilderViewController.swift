//
//  InterfaceBuilderViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

import SWXMLHash

public protocol ViewControllerProtocol {
    var id: String { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var customModuleProvider: String? { get }
    var storyboardIdentifier: String? { get }
    var layoutGuides: [ViewControllerLayoutGuide]? { get }
    var rootView: ViewProtocol? { get }
}

// MARK: - ViewController

public struct ViewController: XMLDecodable, ViewControllerProtocol {

    public let id: String
    public let customClass: String?
    public let customModule: String?
    public let customModuleProvider: String?
    public var storyboardIdentifier: String?
    public let layoutGuides: [ViewControllerLayoutGuide]?
    public let view: View?
    public var rootView: ViewProtocol? { return view }

    static func decode(_ xml: XMLIndexer) throws -> ViewController {
        return ViewController.init(
            id:                   try xml.attributeValue(of: "id"),
            customClass:          xml.attributeValue(of: "customClass"),
            customModule:         xml.attributeValue(of: "customModule"),
            customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
            storyboardIdentifier: xml.attributeValue(of: "storyboardIdentifier"),
            layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.all.flatMap(decodeValue),
            view:                 xml.byKey("view").flatMap(decodeValue)
        )
    }
}

// MARK: - TableViewController

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

