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
        enum Path: Hashable {
            case root(Set<Path>)
            case directory(String, Set<Path>)
            case file(String)
            func hash(into hasher: inout Hasher) {
                name.hash(into: &hasher)
            }
            var name: String {
                switch self {
                case .directory(let name, _), .file(let name): return name
                case .root: return "__root__"
                }
            }
            func find<C: Collection>(path: C) -> Path? where C.Element == String {
                guard let firstPath = path.first else {
                    if case .root = self { return self }
                    return nil
                }
                let restPath = path.dropFirst()
                switch self {
                case .directory(let name, _) where name == firstPath && restPath.isEmpty:
                    return self
                case .directory(let name, let children) where name == firstPath:
                    return children.lazy.compactMap { $0.find(path: path.dropFirst()) }.first
                case .file(let name) where name == firstPath && restPath.isEmpty:
                    return self
                case .file(let name) where name == firstPath:
                    return nil
                case .root(let children):
                    return children.lazy.compactMap { $0.find(path: path) }.first
                default: return nil
                }
            }
        }
        let projectPath: URL
        init(projectPath: URL, tree: Path) {
            self.projectPath = projectPath
            self.tree = tree
        }
        let tree: Path
        enum Error: Swift.Error {
            case noSuchPath
        }
        func subpathsOfDirectory(atPath path: String) throws -> [String] {
            var path = path
            guard let relativePathRange = path.range(of: projectPath.path) else { fatalError() }
            path.removeSubrange(relativePathRange)
            guard let treePath = tree.find(path: path.split(separator: "/").map(String.init)) else {
                throw Error.noSuchPath
            }
            switch treePath {
            case .directory(_, let children), .root(let children):
                return children.map { $0.name }
            case .file: fatalError()
            }
        }

        func isDirectory(_ url: String) -> Bool {
            var path = url
            guard let relativePathRange = path.range(of: projectPath.path) else { fatalError() }
            path.removeSubrange(relativePathRange)
            guard let treePath = tree.find(path: path.split(separator: "/").map(String.init)) else {
                return false
            }
            switch treePath {
            case .file: return false
            case .directory, .root: return true
            }
        }
    }

    func testExpandGlobstar() {
        let projectPath = URL(fileURLWithPath: "./Project")
        do {
            let multiRecursivePath = projectPath.appendingPathComponent("**/Level2_1/**")
            let fileManager = MockFileManager(
                projectPath: projectPath,
                tree: .root(
                    [
                        .directory(
                            "Level1_1",
                            [
                                .file("Level1_1.xib"),
                                .directory("Level2_1", [.file("Level2_1.xib")]),
                                .directory("Level2_2", [.file("Level2_2.xib")])
                            ]
                        ),
                        .directory("Level1_2", [.file("Level1_2.xib")])
                    ]
                )
            )
            let expanded = expandGlobstar(pattern: multiRecursivePath.path, fileManager: fileManager)
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
