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
}
