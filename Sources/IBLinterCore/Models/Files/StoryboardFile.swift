//
//  StoryboardFile.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

import SWXMLHash
import Foundation

public class StoryboardFile: InterfaceBuilderFile {

    public var pathString: String

    public let document: StoryboardDocument

    public init(path: String) throws {
        self.pathString = path
        self.document = try type(of: self).parseContent(pathString: path)
    }

    private static func parseContent(pathString: String) throws -> StoryboardDocument {
        let parser = InterfaceBuilderParser()
        let content = try String.init(contentsOfFile: pathString)
        return try parser.parseStoryboard(xml: content)
    }
}
