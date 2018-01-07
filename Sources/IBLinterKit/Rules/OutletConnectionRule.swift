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

        public func validate(xib: XibFile, swiftParser: SwiftIBParser) -> [Violation] {
            fatalError()
        }

        private func validate(for view: ViewProtocol) -> [Violation] {
            fatalError()
        }

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let viewControllers = scenes.flatMap { $0.viewController }
            let views = viewControllers.flatMap { $0.rootView }
            fatalError()
        }

    }
}
