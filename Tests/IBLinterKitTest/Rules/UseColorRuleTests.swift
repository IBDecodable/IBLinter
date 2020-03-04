//
//  File.swift
//  
//
//  Created by Mark Fernandez on 2/19/20.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class UseColorRuleTests: XCTestCase {

    let fixture = Fixture()

    func testColorProperties() {
        let url = fixture.path("Resources/Rules/AmbiguousViewRule/AmbiguousConstraint.storyboard")
        let config = Config(disabledRules: [], enabledRules: [], excluded: [], included: [], customModuleRule: [], colorRule: [UseColorConfig(allowedColors: ["whiteColor", "blackColor"])], reporter: "xcode")
        let rule = Rules.UseColorRule(context: .mock(from: config))
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
//        let violations = try! rule.validate(xib: .init(url: url))
        XCTAssertEqual(violations.count, 1)
    }
}
