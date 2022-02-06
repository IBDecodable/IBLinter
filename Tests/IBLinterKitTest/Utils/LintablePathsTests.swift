@testable import IBLinterKit
import XCTest


class LintablePathsTests: XCTestCase {

    let fixture = Fixture()

    func testExcludedDirectory() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: ["Level1_1"], included: [],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let validator = Validator(externalRules: [])
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let lintablePaths = validator.lintablePaths(workDirectory: projectPath, config: config).xib

        XCTAssertEqual(
            lintablePaths.map { $0.path },
            [projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path]
        )
    }

    func testExcludedFile() {
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: ["Level1_2/Level1_2.xib", "\(projectPath.path)/Level1_1/Level2_1/Label2_1.xib"], included: [],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let validator = Validator(externalRules: [])
        let lintablePaths = validator.lintablePaths(workDirectory: projectPath, config: config).xib

        XCTAssertEqual(
            lintablePaths.map { $0.path }.sorted(),
            [projectPath.appendingPathComponent("Level1_1/Level1_1.xib").path,
             projectPath.appendingPathComponent("Level1_1/Level2_1/Level2_1.xib").path,
             projectPath.appendingPathComponent("Level1_1/Level2_2/Level2_2.xib").path]
        )
    }

    func testIncludedDirectort() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: [], included: ["Level1_2"],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let validator = Validator(externalRules: [])
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let lintablePaths = validator.lintablePaths(workDirectory: projectPath, config: config).xib

        XCTAssertEqual(
            lintablePaths.map { $0.path },
            [projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path]
        )
    }

    func testIncludedFile() {
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: [], included: [
                "Level1_1/Level2_1/Level2_1.xib",
                "\(projectPath.path)/Level1_1/Level2_1/Level2_1.xib"
            ],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let validator = Validator(externalRules: [])
        let lintablePaths = validator.lintablePaths(workDirectory: projectPath, config: config).xib

        XCTAssertEqual(
            lintablePaths.map { $0.path },
            [projectPath.appendingPathComponent("Level1_1/Level2_1/Level2_1.xib").path]
        )
    }   

    func testIncludedAndExcluded() {
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: ["Level1_1"], included: ["Level1_1/Level2_1"],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let validator = Validator(externalRules: [])
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let lintablePaths = validator.lintablePaths(workDirectory: projectPath, config: config).xib

        XCTAssertEqual(lintablePaths, [])
    }
    
    func testIncludedFilePath() {
        let projectPath = fixture.path("Resources/Utils/Glob/ProjectMock")
        let config = Config(
            disabledRules: [], enabledRules: [],
            excluded: [], included: [
                "Level1_1/Level2_1/Label2_1.xib", "Level1_2",
                "\(projectPath.path)/Level1_1/Level2_1/Label2_1.xib"
            ],
            customModuleRule: [], baseClassRule: [], reporter: ""
        )
        let validator = Validator(externalRules: [])
        let lintablePaths = validator.lintablePaths(workDirectory: projectPath, config: config).xib.map { $0.path }
        
        XCTAssertTrue(lintablePaths.contains(projectPath.appendingPathComponent("Level1_1/Level2_1/Label2_1.xib").path))
        XCTAssertTrue(lintablePaths.contains(projectPath.appendingPathComponent("Level1_2/Level1_2.xib").path))
        XCTAssertEqual(lintablePaths.count, 2)
    }
}
