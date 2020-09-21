@testable import IBLinterKit
import XCTest
import IBDecodable

class StackViewBackgroundColorRuleTests: XCTestCase {

    let fixture = Fixture()

    func testStackViewBackgroundColorStoryboard() {
        let url = fixture.path("Resources/Rules/StackViewBackgroundColorRule/StackViewBackgroundColorRule.storyboard")
        let rule = Rules.StackViewBackgroundColorRule(context: .mock(from: .default))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 1)
    }

    func testStackViewBackgroundColorXib() {
        let url = fixture.path("Resources/Rules/StackViewBackgroundColorRule/StackViewBackgroundColorRule.xib")
        let rule = Rules.StackViewBackgroundColorRule(context: .mock(from: .default))
        let violations = try! rule.validate(xib: XibFile(url: url))
        XCTAssertEqual(violations.count, 2)
    }
}
