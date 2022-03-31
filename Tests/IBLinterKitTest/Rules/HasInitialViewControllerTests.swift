//
//  HasInitialViewController.swift
//  IBLinterKitTest
//
//  Created by Blazej SLEBODA on 24/03/2022
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class HasInitialViewControllerTests: XCTestCase {

    let fixture = Fixture()
    
    private var storyboardGood: StoryboardFile!
    private var storyboardBad: StoryboardFile!
    
    override func setUp() {
        super.setUp()
        
        let pathToStoryboardGood = fixture.path("Resources/Rules/HasInitialViewController/HasInitialViewControllerGood.storyboard")
        storyboardGood = try! .init(url: pathToStoryboardGood)
        
        let pathToStoryboardBad = fixture.path("Resources/Rules/HasInitialViewController/HasInitialViewControllerBad.storyboard")
        storyboardBad = try! .init(url: pathToStoryboardBad)
    }
    
    func testHasInitialViewControllerInGoodStoryboard() {
        let rule = createRule()
        let warnings = rule.validate(storyboard: storyboardGood)
        XCTAssertTrue(warnings.isEmpty)
    }

    func testHasInitialViewControllerInBadStoryboard() {
        let rule = createRule()
        let warnings = rule.validate(storyboard: storyboardBad)
        XCTAssertEqual(warnings.count, 1)
    }
    
    private func createRule() -> Rule {
        Rules.HasInitialViewControllerRule(context: .mock(from: .init()))
    }
}
