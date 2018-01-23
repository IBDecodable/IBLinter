//
//  SwiftFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2018/01/12.
//

import Foundation

public class SwiftFile: FileProtocol {
    public var pathString: String
    public var fileName: String {
        return pathString.components(separatedBy: "/").last!
    }

    public init(path: String) {
        self.pathString = path
    }
}

