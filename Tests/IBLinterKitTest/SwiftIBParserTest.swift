import XCTest
import IBLinterCore

class SwiftIBParserTest: XCTestCase {

    func testSwiftIBParser() {
        let path = "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift"
        let swiftParser = SwiftIBParser(swiftFilePaths: [path])

        let classStructure = SwiftIBParser.Class(
            name: "IBConnectionViewController",
            outlets: [
                SwiftIBParser.Declaration(
                    name: "label", line: 5, column: 23,
                    url: URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift").absoluteURL,
                    isOptional: false
                ),
                SwiftIBParser.Declaration(
                    name: "buttons", line: 6, column: 23,
                    url: URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift").absoluteURL,
                    isOptional: false
                )
            ],
            actions: [
                SwiftIBParser.Declaration(
                    name: "touchUpInsideAction:", line: 8, column: 19,
                    url: URL(fileURLWithPath: "Tests/IBLinterKitTest/Resources/IBConnectionViewController.swift").absoluteURL,
                    isOptional: false
                )
            ]
        )
        XCTAssertEqual(swiftParser.classNameToStructure, ["IBConnectionViewController": classStructure])
    }

}
