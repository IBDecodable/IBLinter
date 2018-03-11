//
//  AnyViewController.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewControllerProtocol

public protocol ViewControllerProtocol {
    var id: String { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var customModuleProvider: String? { get }
    var storyboardIdentifier: String? { get }
    var layoutGuides: [ViewControllerLayoutGuide]? { get }
    var rootView: ViewProtocol? { get }
}

// MARK: - AnyViewController

public struct AnyViewController: XMLDecodable {

    public let viewController: ViewControllerProtocol

    init(_ viewController: ViewControllerProtocol) {
        self.viewController = viewController
    }

    static func decode(_ xml: XMLIndexer) throws -> AnyViewController {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "viewController": return try AnyViewController(ViewController.decode(xml))
        case "tableViewController": return try AnyViewController(TableViewController.decode(xml))
        default: throw IBError.unsupportedViewControllerClass(elementName)
        }
    }
}

// MARK: - ViewControllerLayoutGuide

public struct ViewControllerLayoutGuide: XMLDecodable {
    public let id: String
    public let type: String

    static func decode(_ xml: XMLIndexer) throws -> ViewControllerLayoutGuide {
        return try ViewControllerLayoutGuide.init(
            id: xml.attributeValue(of: "id"),
            type: xml.attributeValue(of: "type")
        )
    }
}
