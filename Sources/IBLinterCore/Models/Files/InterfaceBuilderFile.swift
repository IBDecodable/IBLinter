//
//  InterfaceBuilderFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/13.
//

public protocol InterfaceBuilderFile {
    var pathString: String { get }
    var fileName: String { get }
}

extension InterfaceBuilderFile {
    public var fileName: String {
        return pathString.components(separatedBy: "/").last!
    }
}
