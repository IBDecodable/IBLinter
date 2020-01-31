//
//  ImageResourcesRuleTests.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

@testable import IBLinterKit
import XCTest
import IBDecodable

class ImageResourcesRuleTests: XCTestCase {

    let fixture = Fixture()

    func testImageResources() {
        let url = fixture.path("Resources/Rules/ImageResourcesRule/StoryboardAsset.storyboard")
        let assetURL = fixture.path("Resources/Rules/ImageResourcesRule/Media.xcassets")
        let rule = Rules.ImageResourcesRule(catalogs: [.init(path: assetURL.path)])
        let violations = try! rule.validate(storyboard: StoryboardFile(url: url))
        XCTAssertEqual(violations.count, 4)
    }
}
