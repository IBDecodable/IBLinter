//
//  HidesBottomBarRuleTests.swift
//  IBLinterKit
//
//  Created by ykkd on 2022/02/06.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class HidesBottomBarRuleTests: XCTestCase {

    let fixture = Fixture()
    
    var storyboardHidesBottomBarWhenPushedYes: StoryboardFile!
    var storyboardHidesBottomBarWhenPushedNo: StoryboardFile!
    
    override func setUp() {
        super.setUp()
        
        let showUrl = fixture.path("Resources/Rules/HidesBottomBarRule/HidesBottomBarYesViewController.storyboard")
        let hideUrl = fixture.path("Resources/Rules/HidesBottomBarRule/HidesBottomBarNoViewController.storyboard")
        
        storyboardHidesBottomBarWhenPushedYes = try! .init(url: showUrl)
        storyboardHidesBottomBarWhenPushedNo = try! .init(url: hideUrl)
        
    }

    func testHidesBottomBarWithExcludeViolation() {
        let hidesBottomBarConfig = HidesBottomBarConfig(excludedViewControllers: ["HidesBottomBarNoViewController"])
        let ibLinterConfig = Config(hidesBottomBarRule: hidesBottomBarConfig)
        let rule = Rules.HidesBottomBarRule(context: .mock(from: ibLinterConfig))
        
        let noViolations = rule.validate(storyboard: storyboardHidesBottomBarWhenPushedNo)
        XCTAssertTrue(noViolations.isEmpty)
        
        let yesViolations = rule.validate(storyboard: storyboardHidesBottomBarWhenPushedYes)
        XCTAssertTrue(yesViolations.isEmpty)
    }
    
    func testHidesBottomBarWithIncludeViolation() {
        let hidesBottomBarConfig = HidesBottomBarConfig(excludedViewControllers: ["HidesBottomBarYesViewController"])
        let ibLinterConfig = Config(hidesBottomBarRule: hidesBottomBarConfig)
        let rule = Rules.HidesBottomBarRule(context: .mock(from: ibLinterConfig))
        
        let noViolations = rule.validate(storyboard: storyboardHidesBottomBarWhenPushedNo)
        XCTAssertEqual(noViolations.count, 1)
        
        let yesViolations = rule.validate(storyboard: storyboardHidesBottomBarWhenPushedYes)
        XCTAssertTrue(yesViolations.isEmpty)
    }
}
