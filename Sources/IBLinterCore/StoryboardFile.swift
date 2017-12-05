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
    public var fileName: String {
        return pathString.components(separatedBy: "/").last!
    }

    public var content: String {
        get {
            if _content == nil {
                _content = try! String.init(contentsOfFile: pathString)
            }
            return _content!
        }

        set {
            _content = newValue
        }
    }

    private var _content: String?

    public lazy var document: InterfaceBuilderNode.StoryboardDocument = {
        let parser = InterfaceBuilderParser.init(with: self._xmlParser)
        do {
            return try parser.parseStoryboard(xml: self.content)
        } catch let error {
            fatalError("parse error \(self.pathString): \(error)")
        }
    }()

    private let _xmlParser: XMLParserProtocol

    public init(path: String, xmlParser: XMLParserProtocol = SWXMLHash.config { _ in }) {
        self.pathString = path
        self._xmlParser = xmlParser
    }
}
