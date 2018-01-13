//
//  OutletConnectionRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/01/04.
//

import IBLinterCore

extension Rules {

    public struct OutletConnectionRule: Rule {

        public static var identifier: String = "outlet_connection"

        public init() {}

        public class Mapper {
            public private(set) var idToClassName: [String: String] = [:]
            public private(set) var classNameToConnection: [String: [InterfaceBuilderNode.View.Connection]] = [:]

            public init(view: ViewProtocol) {
                mappingIdToClassName(for: view)
                mappingClassNameToConnection(for: view)
            }

            public init(viewController: ViewControllerProtocol) {
                mappingIdToClassName(for: viewController)
                mappingClassNameToConnection(for: viewController)
                guard let rootView = viewController.rootView else { return }
                mappingIdToClassName(for: rootView)
                mappingClassNameToConnection(for: rootView)
            }

            private func mappingIdToClassName(for viewController: ViewControllerProtocol) {
                if let customClassName = viewController.customClass {
                    idToClassName[viewController.id] = customClassName
                    classNameToConnection[customClassName] = []
                }
            }

            private func mappingIdToClassName(for view: ViewProtocol) {
                if let customClassName = view.customClass {
                    idToClassName[view.id] = customClassName
                    classNameToConnection[customClassName] = []
                }
                view.subviews?.forEach(mappingIdToClassName)
            }

            private func mappingClassNameToConnection(for view: ViewProtocol) {
                guard let connections = view.connections else {
                    view.subviews?.forEach(mappingClassNameToConnection)
                    return
                }
                connections.forEach { [weak self] connection in
                    switch connection {
                    case .outlet:
                        guard let className = view.customClass else { return }
                        self?.classNameToConnection[className]?.append(connection)
                    case .outletCollection:
                        guard let className = view.customClass else { return }
                        self?.classNameToConnection[className]?.append(connection)
                    case .action(_, let destination, _, _):
                        guard let className = self?.idToClassName[destination] else { return }
                        self?.classNameToConnection[className]?.append(connection)
                    }
                }
            }

            private func mappingClassNameToConnection(for viewController: ViewControllerProtocol) {
                guard let connections = viewController.connections else { return }
                connections.forEach { [weak self] connection in
                    switch connection {
                    case .outlet:
                        guard let className = viewController.customClass else { return }
                        self?.classNameToConnection[className]?.append(connection)
                    case .outletCollection:
                        guard let className = viewController.customClass else { return }
                        self?.classNameToConnection[className]?.append(connection)
                    case .action(_, let destination, _, _):
                        guard let className = self?.idToClassName[destination] else { return }
                        self?.classNameToConnection[className]?.append(connection)
                    }
                }
            }
        }

        private static let uiKitClassConnections: [String: SwiftIBParser.Class] = {
            let uiKitOutlets: [String: [String]] = [
                "UITextField": ["delegate"],
                "UITableView": ["delegate", "dataSource"],
                "UITableViewCell": ["accessoryView", "backgroundView", "editingAccessoryView", "selectedBackgroundView"],
                "UICollectionView": ["delegate", "dataSource", "prefetchDataSource"],
                "UICollectionViewCell": ["backgroundView", "selectedBackgroundView"],
                "UITextView": ["delegate"],
                "UIScrollView": ["delegate"],
                "UIPickerView": ["delegate", "dataSource"],
                "MKMapView": ["delegate"],
                "GLKView": ["delegate"],
                "SCNView": ["delegate"],
                "UIWebView": ["delegate"],
                "UITapGestureRecognizer": ["delegate"],
                "UIPinchGestureRecognizer": ["delegate"],
                "UIRotationGestureRecognizer": ["delegate"],
                "UISwipeGestureRecognizer": ["delegate"],
                "UIPanGestureRecognizer": ["delegate"],
                "UIScreenEdgePanGestureRecognizer": ["delegate"],
                "UILongPressGestureRecognizer": ["delegate"],
                "UIGestureRecognizer": ["delegate"],
                "UINavigationBar": ["delegate"],
                "UINavigationItem": ["backBarButtonItem", "leftBarButtonItem", "rightBarButtonItem", "titleView"],
                "UIToolbar": ["delegate"],
                "UITabBar": ["delegate"],
                "UISearchBar": ["delegate"],
                "UIViewController": ["view"]
            ]

            var dict: [String: SwiftIBParser.Class] = [:]
            for (name, outlets) in uiKitOutlets {
                var connections = outlets.map { outlet in
                    SwiftIBParser.Connection.outlet(
                        property: outlet, isOptional: false,
                        declaration: .init(line: 0, column: 0, path: nil))
                }
                dict[name] = SwiftIBParser.Class.init(
                    file: .init(path: ""), name: name,
                    connections: connections, inheritedClassNames: [],
                    declaration: .init(line: 0, column: 0, path: nil))
            }

            return dict
        }()

        public func validate(xib: XibFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.map(Mapper.init(view: ))
                .flatMap { self.validate(for: $0, file: xib, swiftParser: swiftParser) }
        }

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let viewControllers = scenes.flatMap { $0.viewController }
            let mappers = viewControllers.map(Mapper.init(viewController: ))
            return mappers.flatMap { self.validate(for: $0, file: storyboard, swiftParser: swiftParser) }
        }

        private func validate(for mapper: Mapper, file: FileProtocol, swiftParser: SwiftIBParser) -> [Violation] {
            return missingElements(for: mapper, swiftParser: swiftParser) +
                unnecessaryElements(for: mapper, swiftParser: swiftParser, file: file)
        }

        private func missingElements(for mapper: Mapper, swiftParser: SwiftIBParser) -> [Violation] {

            return mapper.classNameToConnection.flatMap { (className, ibConnections) -> [Violation] in
                guard !ibConnections.isEmpty else { return [] }
                guard let swiftClass = swiftParser.classNameToStructure[className] else { return [] }

                return ibConnections
                    .filter { !self.match(className: className, swiftParser: swiftParser, connection: $0) }
                    .map { (connection: InterfaceBuilderNode.View.Connection) -> Violation in
                        let message: String = {
                            switch connection {
                            case .outlet(let property, _, _):
                                return "IBOutlet missing: \(property) is not implemented"
                            case .outletCollection(let property, _, _, _):
                                return "IBOutletCollection missing: \(property) is not implemented"
                            case .action(let selector, _, _, _):
                                return "IBAction missing: \(selector) is not implemented"
                            }
                        }()
                        return Violation(file: swiftClass.file, message: message, level: .error,
                                         location: .init(line: swiftClass.declaration.line,
                                                         column: swiftClass.declaration.column))
                }
            }
        }

        private func unnecessaryElements(for mapper: Mapper, swiftParser: SwiftIBParser, file: FileProtocol) -> [Violation] {
            return swiftParser.classNameToStructure.flatMap { className, swiftClass -> [Violation] in
                guard !swiftClass.connections.isEmpty else { return [] }
                guard let ibConnections = mapper.classNameToConnection[className] else { return [] }

                return swiftClass.connections
                    .filter { swiftConnection in
                        !ibConnections.contains(where: { self.matchConnection(viewConnection: $0, swiftConnection: swiftConnection)})
                    }
                    .map { connection in
                        let message: String = {
                            switch connection {
                            case .outlet(let property, _, _):
                                return "IBOutlet missing: \(property) is not connected"
                            case .action(let selector, _):
                                return "IBAction missing: \(selector) is not connected"
                            }
                        }()
                        return Violation(file: file, message: message, level: .error)
                }

            }
        }

        private func match(className: String, swiftParser: SwiftIBParser, connection: InterfaceBuilderNode.View.Connection) -> Bool {
            let _match: (SwiftIBParser.Class, InterfaceBuilderNode.View.Connection) -> Bool = { klass, connection in
                klass.connections.contains(where: {
                    self.matchConnection(viewConnection: connection, swiftConnection: $0)
                })
            }

            if let uiKitClass = type(of: self).uiKitClassConnections[className] {
                return _match(uiKitClass, connection)
            } else if let klass = swiftParser.classNameToStructure[className] {
                if _match(klass, connection) {
                    return true
                } else {
                    return klass.inheritedClassNames.contains {
                        match(className: $0, swiftParser: swiftParser, connection: connection)
                    }
                }
            } else {
                return false
            }
        }


        private func matchConnection(viewConnection: InterfaceBuilderNode.View.Connection, swiftConnection: SwiftIBParser.Connection) -> Bool {
            switch (viewConnection, swiftConnection) {
            case (.outlet(let viewProperty, _, _),
                  .outlet(let swiftProperty, let isOptional, _)):
                return viewProperty == swiftProperty || isOptional
            case (.outletCollection(let viewProperty, _, _, _),
                  .outlet(let swiftProperty, let isOptional, _)):
                return viewProperty == swiftProperty || isOptional
            case (.action(let viewSelector, _, _, _),
                  .action(let swiftSelector, _)):
                return viewSelector == swiftSelector
            default:
                return false
            }
        }
    }
}
