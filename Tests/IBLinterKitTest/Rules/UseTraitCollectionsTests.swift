//
//  UseTraitCollectionsTests.swift
//  IBLinterKitTest
//
//  Created by Blazej SLEBODA on 13/09/2020
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class UseTraitCollectionsTests: XCTestCase {

    let fixture = Fixture()
    
    var storyboardUseTraitCollectionsYes: StoryboardFile!
    var storyboardUseTraitCollectionsNo: StoryboardFile!
    
    override func setUp() {
        super.setUp()
        
        let disabledUrl = fixture.path("Resources/Rules/UseTraitCollectionsRule/UseTraitCollectionsNoTest.storyboard")
        let enabledUrl = fixture.path("Resources/Rules/UseTraitCollectionsRule/UseTraitCollectionsYesTest.storyboard")
        
        storyboardUseTraitCollectionsYes = try! .init(url: enabledUrl)
        storyboardUseTraitCollectionsNo = try! .init(url: disabledUrl)
        
    }
    
    func testUseTraitCollectionsNoConfig() {
        let ibLinterConfig = Config.default
        let rule = Rules.UseTraitCollections(context: .mock(from: ibLinterConfig))
        
        let noViolations = rule.validate(storyboard: storyboardUseTraitCollectionsNo)
        XCTAssertEqual(noViolations.count, 1)
        
        let yesViolations = rule.validate(storyboard: storyboardUseTraitCollectionsYes)
        XCTAssertTrue(yesViolations.isEmpty)
    }

    func testUseTraitCollectionsConfigWithTrue() {
        let useTraitCollectionsConfig = UseTraitCollectionsConfig(enabled: true)
        let ibLinterConfig = Config(useTraitCollectionsRule: useTraitCollectionsConfig)
        let rule = Rules.UseTraitCollections(context: .mock(from: ibLinterConfig))
        
        let noViolations = rule.validate(storyboard: storyboardUseTraitCollectionsNo)
        XCTAssertEqual(noViolations.count, 1)
        
        let yesViolations = rule.validate(storyboard: storyboardUseTraitCollectionsYes)
        XCTAssertTrue(yesViolations.isEmpty)
    }

    func testUseTraitCollectionsConfigWithFalse() {
        let useTraitCollectionsConfig = UseTraitCollectionsConfig(enabled: false)
        let ibLinterConfig = Config(useTraitCollectionsRule: useTraitCollectionsConfig)
        let rule = Rules.UseTraitCollections(context: .mock(from: ibLinterConfig))
        
        let noViolations = rule.validate(storyboard: storyboardUseTraitCollectionsNo)
        XCTAssertTrue(noViolations.isEmpty)
        
        let yesViolations = rule.validate(storyboard: storyboardUseTraitCollectionsYes)
        XCTAssertEqual(yesViolations.count, 1)
    }
}
