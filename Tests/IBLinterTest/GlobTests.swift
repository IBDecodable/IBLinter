@testable import IBLinterKit
@testable import IBLinter
import XCTest


class GlobTests: XCTestCase {

    func testSimplePath() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            glob(pattern: projectPath.path).map { $0.path },
            [projectPath.path]
        )
    }

    func testSimpleFile() {
        let filePath = bundleURL.appendingPathComponent("ProjectMock/Level1_1/Level1_1.xib")
        XCTAssertEqual(
            glob(pattern: filePath.path).map { $0.path },
            [filePath.path]
        )
    }

    func testSubPaths() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            glob(pattern: projectPath.appendingPathComponent("*").path).map { $0.path },
            [
                projectPath.appendingPathComponent("Level1_1").path,
                projectPath.appendingPathComponent("Level1_2").path
            ]
        )
    }

    func testRecursiveSubPaths() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            glob(pattern: projectPath.appendingPathComponent("**").path).map { $0.path }.sorted(),
            [
                projectPath.path,
                projectPath.appendingPathComponent("Level1_1").path,
                projectPath.appendingPathComponent("Level1_1/Level1_1.xib").path,
                projectPath.appendingPathComponent("Level1_1/Level2_1").path,
                projectPath.appendingPathComponent("Level1_1/Level2_1/Level2_1.xib").path,
                projectPath.appendingPathComponent("Level1_1/Level2_2").path,
                projectPath.appendingPathComponent("Level1_1/Level2_2/Level2_2.xib").path,
                projectPath.appendingPathComponent("Level1_2").path,
                projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path,
            ].sorted()
        )
    }

    func testMultiRecursiveSubPaths() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            glob(pattern: projectPath.appendingPathComponent("**/Level2_1/**").path).map { $0.path },
            [
                projectPath.appendingPathComponent("Level1_1/Level2_1").path,
                projectPath.appendingPathComponent("Level1_1/Level2_1/Level2_1.xib").path
            ]
        )
    }

    func testMultiRecursivePaths() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            glob(pattern: projectPath.appendingPathComponent("**/Level2_1/*.xib").path).map { $0.path },
            [
                projectPath.appendingPathComponent("Level1_1/Level2_1/Level2_1.xib").path
            ]
        )
    }

    class MockFileManager: GlobFileManager {
        let projectPath: URL
        init(projectPath: URL) {
            self.projectPath = projectPath
        }
        func subpathsOfDirectory(atPath path: String) throws -> [String] {
            switch URL(fileURLWithPath: path).path {
            case projectPath.path:
                return [
                    "Level1_1",
                    "Level1_2",
                ]
            case projectPath.appendingPathComponent("Level1_1/").path:
                return [
                    "Level1_1.xib",
                    "Level2_1",
                    "Level2_2",
                ]
            case projectPath.appendingPathComponent("Level1_2/").path:
                return ["Level1_2.xib"]
            case projectPath.appendingPathComponent("Level1_1/Level2_1").path:
                return ["Level2_1.xib"]
            case projectPath.appendingPathComponent("Level1_1/Level2_2").path:
                return ["Level2_2.xib"]
            default:
                XCTFail("\(path) is unexpected directory.")
                return []
            }
        }

        func isDirectory(_ url: String) -> Bool {
            switch URL(fileURLWithPath: url).path {
            case projectPath.path:
                return true
            case projectPath.appendingPathComponent("Level1_1/").path:
                return true
            case projectPath.appendingPathComponent("Level1_1/Level1_1.xib").path:
                return false
            case projectPath.appendingPathComponent("Level1_1/Level2_1/").path:
                return true
            case projectPath.appendingPathComponent("Level1_1/Level2_2/").path:
                return true
            case projectPath.appendingPathComponent("Level1_2/").path:
                return true
            case projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path:
                return false
            case projectPath.appendingPathComponent("Level1_1/Level2_1/").path:
                return true
            case projectPath.appendingPathComponent("Level1_1/Level2_1/Level2_1.xib").path:
                return false
            case projectPath.appendingPathComponent("Level1_1/Level2_2/").path:
                return true
            case projectPath.appendingPathComponent("Level1_1/Level2_2/Level2_2.xib").path:
                return false
            default:
                XCTFail("\(url) is unexpected directory.")
                return false
            }
        }
    }

    func testExpandGlobstar() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        do {
            let multiRecursivePath = projectPath.appendingPathComponent("**/Level2_1/**")
            let expanded = expandGlobstar(pattern: multiRecursivePath.path, fileManager: MockFileManager(projectPath: projectPath))
            XCTAssertEqual(
                expanded.map { URL(fileURLWithPath: $0).path }.sorted(),
                [
                    projectPath.appendingPathComponent("Level1_1/Level2_1").path,
                    projectPath.appendingPathComponent("Level1_1/Level2_1/*").path
                ]
            )
        }
    }
}
