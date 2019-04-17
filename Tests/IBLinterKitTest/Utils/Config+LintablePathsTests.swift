@testable import IBLinterKit
import XCTest


class ConfigLintablePathsTests: XCTestCase {

    let fixture = Fixture()

    func testIncluded() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: ["Level1_1"], included: [],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let lintablePaths = config.lintablePaths(workDirectory: projectPath).xib

        XCTAssertEqual(
            lintablePaths.map { $0.path },
            [projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path]
        )
    }

    func testExcluded() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: [], included: ["Level1_2"],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let lintablePaths = config.lintablePaths(workDirectory: projectPath).xib

        XCTAssertEqual(
            lintablePaths.map { $0.path },
            [projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path]
        )
    }

    func testIncludedAndExcluded() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: ["Level1_1"], included: ["Level1_1/Level2_1"],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let lintablePaths = config.lintablePaths(workDirectory: projectPath).xib

        XCTAssertEqual(lintablePaths, [])
    }
}
