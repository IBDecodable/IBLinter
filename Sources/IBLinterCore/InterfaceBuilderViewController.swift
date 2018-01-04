//
//  InterfaceBuilderViewController.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

public protocol ViewControllerProtocol {
    var id: String { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var customModuleProvider: String? { get }
    var connections: [InterfaceBuilderNode.View.Connection]? { get }
    var layoutGuides: [InterfaceBuilderNode.ViewControllerLayoutGuide]? { get }
    var rootView: ViewProtocol? { get }
}

extension InterfaceBuilderNode {

    public enum ViewController: XMLDecodable, ViewControllerProtocol {
        case viewController(ViewController)
        case tableViewController(TableViewController)

        private var _viewController: ViewControllerProtocol {
            switch self {
            case .viewController(let viewController): return viewController
            case .tableViewController(let tableViewController): return tableViewController
            }
        }

        public var id: String { return _viewController.id }
        public var customClass: String? { return _viewController.customClass }
        public var customModule: String? { return _viewController.customModule }
        public var customModuleProvider: String? { return _viewController.customModuleProvider }
        public var connections: [InterfaceBuilderNode.View.Connection]? { return _viewController.connections }
        public var layoutGuides: [InterfaceBuilderNode.ViewControllerLayoutGuide]? {
            return _viewController.layoutGuides
        }
        public var rootView: ViewProtocol? { return _viewController.rootView }


        // MARK: - ViewControllers
        public var viewController: ViewController? {
            switch self {
            case .viewController(let viewController):
                return viewController
            default: return nil
            }
        }

        public var tableViewController: TableViewController? {
            switch self {
            case .tableViewController(let tableViewController):
                return tableViewController
            default: return nil
            }
        }


        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.ViewController {
            guard let elementName = xml.elementNode?.name else { throw Error.elementNotFound }
            switch elementName {
            case "viewController":
                return try .viewController(decodeValue(xml))
            case "tableViewController":
                return try .tableViewController(decodeValue(xml))
            default:
                throw Error.unsupportedViewControllerClass(elementName)
            }
        }

        public struct ViewController: XMLDecodable, ViewControllerProtocol {
            public let id: String
            public let customClass: String?
            public let customModule: String?
            public let customModuleProvider: String?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let layoutGuides: [ViewControllerLayoutGuide]?
            public let view: View.View?
            public var rootView: ViewProtocol? { return view }

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.ViewController.ViewController {
                return ViewController.init(
                    id:                   try xml.attributeValue(of: "id"),
                    customClass:          xml.attributeValue(of: "customClass"),
                    customModule:         xml.attributeValue(of: "customModule"),
                    customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
                    connections:          xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.allElements.flatMap(decodeValue),
                    view:                 xml.byKey("view").flatMap(decodeValue)
                )
            }
        }

        public struct TableViewController: XMLDecodable, ViewControllerProtocol {
            public let id: String
            public let customClass: String?
            public let customModule: String?
            public let customModuleProvider: String?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let layoutGuides: [ViewControllerLayoutGuide]?
            public let tableView: View.TableView?
            public var rootView: ViewProtocol? { return tableView }

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.ViewController.TableViewController {
                return TableViewController.init(
                    id:                   try xml.attributeValue(of: "id"),
                    customClass:          xml.attributeValue(of: "customClass"),
                    customModule:         xml.attributeValue(of: "customModule"),
                    customModuleProvider: xml.attributeValue(of: "customModuleProvider"),
                    connections:          xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    layoutGuides:         xml.byKey("layoutGuides")?.byKey("viewControllerLayoutGuide")?.allElements.flatMap(decodeValue),
                    tableView:            xml.byKey("tableView").flatMap(decodeValue)
                )
            }
        }
    }
}
