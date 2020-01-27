@testable import IBLinterKit
import XCTest

class ColorResourcesRuleTests: XCTestCase {

    let fixture = Fixture()

    func testColorResources() {
        let url = fixture.path("Resources/Rules/ColorResourcesRule/ColorResources.xib")
        let assetURL = fixture.path("Resources/Rules/ColorResourcesRule/Colors.xcassets")
        let rule = Rules.ColorResourcesRule(catalogs: [.init(path: assetURL.path)])
        let violations = try! rule.validate(xib: .init(url: url))
        XCTAssertEqual(violations.count, 1)
    }
}
