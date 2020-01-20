@testable import IBLinterKit
import XCTest
import IBDecodable

class ReuseIdentifierRuleTests: XCTestCase {
    
    let fixture = Fixture()
    
    func testReuseIdentifierStoryboard() {
        let url = fixture.path("Resources/Rules/ReuseIdentifierRule/ReuseIdentifier.storyboard")
        let rule = Rules.ReuseIdentifier(context: .mock(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }
}
