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
            Set(glob(pattern: projectPath.appendingPathComponent("*").path).map { $0.path }),
            [
                projectPath.appendingPathComponent("Level1_1").path,
                projectPath.appendingPathComponent("Level1_2").path
            ]
        )
    }

    func testRecursiveSubPaths() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            Set(glob(pattern: projectPath.appendingPathComponent("**").path).map { $0.path }),
            [
                projectPath.appendingPathComponent("Level1_1").path,
                projectPath.appendingPathComponent("Level1_2").path,
            ]
        )
    }

    func testMultiRecursiveSubPaths() {
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        XCTAssertEqual(
            Set(glob(pattern: projectPath.appendingPathComponent("**/Level2_1/**").path).map { $0.path }),
            [
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
            var hashValue: Int { return name.hashValue }
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
        empty: do {
            let fileManager = MockFileManager(projectPath: projectPath, tree: .root([]))
            let expended = Glob(fileManager: fileManager).expandRecursiveStars(pattern: "")
            XCTAssertEqual(expended, [])
        }
        recursive: do {
            let multiRecursivePath = projectPath.appendingPathComponent("**/foo/**")
            let fileManager = MockFileManager(
                projectPath: projectPath,
                tree: .root([
                    .directory("foo", [
                        .file("bar_1"),
                        .directory("bar_2", [
                            .file("baz")]),
                        .directory("bar_3", [
                            .file("baz")])]),
                    .directory("baz", [
                        .directory("bar", [
                            .directory("foo", [
                                .file("xxx")])])])
                    ]
                )
            )
            let expanded = Glob(fileManager: fileManager).expandRecursiveStars(pattern: multiRecursivePath.path)
            XCTAssertEqual(
                Set(expanded.map { URL(fileURLWithPath: $0).path }),
                Set([
                    projectPath.appendingPathComponent("foo/*").path,
                    projectPath.appendingPathComponent("baz/bar/foo/*").path,
                ])
            )
        }
    }
}
