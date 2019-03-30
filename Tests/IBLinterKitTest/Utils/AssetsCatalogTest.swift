@testable import IBLinterKit
import XCTest

class AssetsCatalogTest: XCTestCase {

    let fixture = Fixture()

    func testImageAssets() {
        let url = fixture.path("Resources/Rules/ImageResourcesRule/Media.xcassets")
        let asset = AssetsCatalog.init(path: url.path)
        XCTAssertEqual(asset.name, "Media")
        XCTAssertEqual(
            asset.entries,
            [
                .image(name: "Apple", value: "Apple"),
                .image(name: "Empty", value: "Empty"),
                .group(
                    name: "Folder",
                    items: [
                        .image(name: "AppleNonNamespaced", value: "AppleNonNamespaced")
                    ]
                ),
                .group(
                    name: "Namespace",
                    items: [
                        .image(name: "AppleNamespaced", value: "Namespace/AppleNamespaced"),
                        .group(
                            name: "Nested",
                            items: [
                                .image(name: "EmptyNested", value: "Namespace/EmptyNested"),
                                ]
                        ),
                        .group(
                            name: "NestedNamespace",
                            items: [
                                .image(name: "EmptyNamespaced", value: "Namespace/NestedNamespace/EmptyNamespaced"),
                            ]
                        ),
                    ]
                )
            ]
        )

    }
}
