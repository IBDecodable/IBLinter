@testable import IBLinterKit
import XCTest

class AssetsCatalogTest: XCTestCase {

    func testImageAssets() {
        let url = self.url(forResource: "Media", withExtension: "xcassets")
        let asset = AssetsCatalog.init(path: url.path)
        XCTAssertEqual(asset.name, "Media")
        XCTAssertEqual(
            asset.entries,
            [
                .image(name: "Apple", value: "Apple"),
                .image(name: "Empty", value: "Empty"),
                .group(
                    name: "SubFolder",
                    items: [
                        .image(name: "Orange", value: "SubFolder/Orange")
                    ]
                )
            ]
        )

    }
}
