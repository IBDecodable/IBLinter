@testable import IBLinterKit
import XCTest

class LintCacheTests: XCTestCase {

    func testLoadDiskCache() throws {
        class MockFileManager: CacheFileManager {
            let fixture = Fixture()
            var cacheDir: URL {
                return fixture.path("Resources/Utils/LintCache")
            }
            func modificationDate(for path: String) -> Date? {
                return Date(timeIntervalSinceReferenceDate: 0.0)
            }

            func createCacheDirectory() throws {}
        }
        let config = Config()
        let cache = try LintDiskCache.load(with: MockFileManager(), config: config)
        let violations = cache.violations(for: URL(fileURLWithPath: "/foo/bar/TestView.xib"))
        XCTAssertEqual(violations?.count, 1)
        XCTAssertEqual(violations?[0].level, .warning)
        XCTAssertEqual(violations?[0].message, "Warning message")
    }
}
