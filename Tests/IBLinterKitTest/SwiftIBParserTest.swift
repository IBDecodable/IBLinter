import XCTest
import IBLinterCore

class SwiftIBParserTest: XCTestCase {

    func testSwiftIBParser() {
        let path = "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift"
        let absolutePath = URL.init(fileURLWithPath: path).absoluteString
        let swiftParser = SwiftIBParser(swiftFilePaths: [path])

        let classStructure = SwiftIBParser.Class(
            file: SwiftFile(path: path),
            name: "IBConnectionViewController",
            connections: [
//                .outlet(property: "label", isOptional: false, declaration: .init(line: 5, column: 23, path: absolutePath)),
                .outlet(property: "buttons", isOptional: false, declaration: .init(line: 6, column: 23, path: absolutePath)),
                .action(selector: "touchUpInsideAction:", declaration: .init(line: 8, column: 19, path: absolutePath))
            ], inheritedClassNames: ["UIViewController"],
            declaration: SwiftIBParser.Declaration(line: 3, column: 6, path: absolutePath)
        )
        XCTAssertEqual(swiftParser.classNameToStructure["IBConnectionViewController"], classStructure)
    }

}
