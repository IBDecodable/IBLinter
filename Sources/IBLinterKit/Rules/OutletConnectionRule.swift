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
            guard let views = xib.document.views else { return [] }
            return views.map(Mapper.init(view: ))
                .flatMap { self.validate(for: $0, file: xib, swiftParser: swiftParser) }
        }

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let viewControllers = scenes.flatMap { $0.viewController }
            let views = viewControllers.flatMap { $0.rootView }
            let mappers = viewControllers.map(Mapper.init(viewController: )) + views.map(Mapper.init(view: ))
            return mappers.flatMap { self.validate(for: $0, file: storyboard, swiftParser: swiftParser) }
        }

        private func validate(for mapper: Mapper, file: FileProtocol, swiftParser: SwiftIBParser) -> [Violation] {
            func isEqual(viewConnection: InterfaceBuilderNode.View.Connection, swiftConnection: SwiftIBParser.Connection) -> Bool {
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

            let swiftMissingViolations = mapper.classNameToConnection
                .flatMap { (className, viewConnections) -> [Violation] in

                    guard let classStructure = swiftParser.classNameToStructure[className] else { return [] }
                    let swiftConnections = classStructure.connections

                    return viewConnections.filter { viewConnection in
                        swiftConnections.contains(where: { swiftConnection in
                            !isEqual(viewConnection: viewConnection, swiftConnection: swiftConnection)
                        })
                        }.map { connection in
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
                            return Violation(file: classStructure.file, message: message, level: .error,
                                             location: .init(line: classStructure.declaration.line,
                                                             column: classStructure.declaration.column))
                    }
            }

            // Swift側にあるがInterfaceBuilderに無い
            let ibMissingViolations = swiftParser.classNameToStructure
                .flatMap { className, classStructure -> [Violation] in
                    let viewConnections = mapper.classNameToConnection[className] ?? []
                    let swiftConnections = classStructure.connections

                    return swiftConnections.filter { swiftConnection in
                        viewConnections.contains(where: { viewConnection in
                            !isEqual(viewConnection: viewConnection, swiftConnection: swiftConnection)
                        })
                        }.map { connection in
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

            return swiftMissingViolations + ibMissingViolations
        }

    }
}
