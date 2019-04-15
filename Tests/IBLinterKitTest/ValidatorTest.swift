import Foundation
import XCTest
import IBDecodable
@testable import IBLinterKit

private struct CheckXibRule: Rule {
    init(context: Context) { }
    
    static let identifier = "check_xib"
    static let description = "Warn xib"
    
    func validate(storyboard: StoryboardFile) -> [Violation] {
        return []
    }
    
    func validate(xib: XibFile) -> [Violation] {
        return [
            Violation(pathString: xib.pathString, message: "This is xib", level: .error)
        ]
    }
}

private struct CheckStoryboardRule: Rule {
    init(context: Context) { }
    
    static let identifier = "check_storyboard"
    static let description = "Warn storyboard"
    
    func validate(storyboard: StoryboardFile) -> [Violation] {
        return [
            Violation(pathString: storyboard.pathString, message: "This is storyboard", level: .error)
        ]
    }
    
    func validate(xib: XibFile) -> [Violation] {
        return []
    }
}

final class VaridatorTest: XCTestCase {
    func testValidateXib() {
        let workingDir = Fixture().path("Resources/Validator")
        let validator = Validator(externalRules: [CheckXibRule.self])
        let config = try! Config.load(workingDir.appendingPathComponent(".iblinter.yml"))
        let violations = validator.validate(workDirectory: workingDir, config: config)
        XCTAssertEqual(violations.count, 1)
    }
    
    func testValidateStoryboard() {
        let workingDir = Fixture().path("Resources/Validator")
        let validator = Validator(externalRules: [CheckStoryboardRule.self])
        let config = try! Config.load(workingDir.appendingPathComponent(".iblinter.yml"))
        let violations = validator.validate(workDirectory: workingDir, config: config)
        XCTAssertEqual(violations.count, 1)
    }
}
