//
//  Identifiable.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2018/01/06.
//

public protocol Identifiable {
    var id: String { get }
}

extension Identifiable where Self: ViewProtocol {

    // TODO: use cache
    public func find(by id: String) -> InterfaceBuilderNode.View? {
        if let matched = subviews?.first(where: { $0.id == id }) {
            return matched
        } else {
            return subviews?.lazy.flatMap { $0.find(by: id) }.first
        }
    }
}
