//
//  HasSingleViewControllerTests.swift
//  IBLinterKitTest
//
//  Created by Blazej SLEBODA on 24/03/2022
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class HasSingleViewControllerTests: XCTestCase {

    let fixture = Fixture()
    
    private var storyboardGood: StoryboardFile!
    private var storyboardGoodSingleSceneWithReference: StoryboardFile!
    private var storyboardBadTwoController: StoryboardFile!
    
    
    override func setUp() {
        super.setUp()
        
        let pathToStoryboardGood = fixture.path("Resources/Rules/HasSingleViewController/HasSingleViewControllerGood.storyboard")
        storyboardGood = try! .init(url: pathToStoryboardGood)
        
        let pathToStoryboardGoodSingleSceneWithReference = fixture.path("Resources/Rules/HasSingleViewController/HasSingleViewControllerGoodSingleSceneWithReference.storyboard")
        storyboardGoodSingleSceneWithReference = try! .init(url: pathToStoryboardGoodSingleSceneWithReference)
        
        let pathToStoryboardBadTwoController = fixture.path("Resources/Rules/HasSingleViewController/HasSingleViewControllerBadTwoController.storyboard")
        storyboardBadTwoController = try! .init(url: pathToStoryboardBadTwoController)
    }
    
    func testHasSingleViewControllerInGoodStoryboard() {
        let rule = createRule()
        let warnings = rule.validate(storyboard: storyboardGood)
        XCTAssertTrue(warnings.isEmpty)
    }

    func testHasSingleViewControllerInGoodSingleSceneWithReference() {
        let rule = createRule()
        let warnings = rule.validate(storyboard: storyboardGoodSingleSceneWithReference)
        XCTAssertTrue(warnings.isEmpty)
    }

    func testHasSingleViewControllerInBad() {
        let rule = createRule()
        let warnings = rule.validate(storyboard: storyboardBadTwoController)
        XCTAssertFalse(warnings.isEmpty)
    }
    
    private func createRule() -> Rule {
        Rules.HasSingleViewControllerRule(context: .mock(from: .init()))
    }
}
