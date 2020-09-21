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
    
    var noUrl: URL!
    var yesUrl: URL!
    
    override func setUp() {
        super.setUp()
        noUrl = fixture.path("Resources/Rules/UseTraitCollectionsRule/UseTraitCollectionsNoTest.storyboard")
        yesUrl = fixture.path("Resources/Rules/UseTraitCollectionsRule/UseTraitCollectionsYesTest.storyboard")
    }
    
    func testUseTraitCollectionsWithEmptyConfig() {
        let contextMock = Context.mock(from: .default)
        XCTAssertNil(contextMock.config.useTraitCollectionsRule)
        XCTAssertFalse(Rules.UseTraitCollections.isDefault)
    }
    
    func testUseTraitCollectionsEnabledWithDefaults() {
        let defaultContext = Context.mock(from: Config.init(enabledRules: [Rules.UseTraitCollections.identifier]))
        let ngRule = Rules.UseTraitCollections(context: defaultContext)
        let ngViolations = try! ngRule.validate(xib: XibFile(url: noUrl))
        XCTAssertEqual(ngViolations.count, 1)
        
        let okConfig = Config(useTraitCollectionsRule: UseTraitCollectionsConfig(useTraitCollections: true))
        let okRule = Rules.UseTraitCollections(context: .mock(from: okConfig))
        let okViolations = try! okRule.validate(xib: XibFile(url: yesUrl))
        XCTAssertTrue(okViolations.isEmpty)
    }

    func testUseTraitCollectionsEnabledWithTrue() {
        let ngConfig = Config(useTraitCollectionsRule: UseTraitCollectionsConfig(useTraitCollections: true))
        let ngRule = Rules.UseTraitCollections(context: .mock(from: ngConfig))
        let ngViolations = try! ngRule.validate(xib: XibFile(url: noUrl))
        XCTAssertEqual(ngViolations.count, 1)
        
        let okConfig = Config(useTraitCollectionsRule: UseTraitCollectionsConfig(useTraitCollections: true))
        let okRule = Rules.UseTraitCollections(context: .mock(from: okConfig))
        let okViolations = try! okRule.validate(xib: XibFile(url: yesUrl))
        XCTAssertTrue(okViolations.isEmpty)
    }

    func testUseTraitCollectionsEnabledWithFalse() {
        let config = Config(useTraitCollectionsRule: .some(.init(useTraitCollections: false)))
        let ngRule = Rules.UseTraitCollections(context: .mock(from: config))
        let ngViolations = try! ngRule.validate(xib: XibFile(url: noUrl))
        XCTAssertTrue(ngViolations.isEmpty)
        
        let okRule = Rules.UseTraitCollections(context: .mock(from: config))
        let okViolations = try! okRule.validate(xib: XibFile(url: yesUrl))
        XCTAssertEqual(okViolations.count, 1)
    }
}
