//
//  XibFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/13.
//

import SWXMLHash
import Foundation

public class XibFile: InterfaceBuilderFile {

    public var pathString: String

    public let document: XibDocument

    public init(path: String) throws {
        self.pathString = path
        self.document = try type(of: self).parseContent(pathString: path)
    }

    private static func parseContent(pathString: String) throws -> XibDocument {
        let parser = InterfaceBuilderParser()
        let content = try String.init(contentsOfFile: pathString)
        return try parser.parseXib(xml: content)
    }
}
