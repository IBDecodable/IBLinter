@testable import IBLinterKit
@testable import IBLinter
import XCTest


class ConfigLintablePathsTests: XCTestCase {

    func testIncluded() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: ["Level1"], included: ["Level1/Level2"],
            customModuleRule: [], reporter: ""
        )
        let projectPath = bundleURL.appendingPathComponent("ProjectMock")
        let lintablePaths = config.lintablePaths(workDirectory: projectPath, fileExtension: "xib")

        XCTAssertEqual(
            lintablePaths.map { $0.path },
            [projectPath.appendingPathComponent("Level1/Level2/Level2.xib")].map { $0.path }
        )
    }
}

extension XCTestCase {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }

    var bundleURL: URL {
        if let url = bundle.resourceURL?.appendingPathComponent("Resources"), FileManager.default.isDirectory(url.path) {
            return url
        }
        return URL(fileURLWithPath: "./Tests/IBLinterTest/Resources")
    }
}
