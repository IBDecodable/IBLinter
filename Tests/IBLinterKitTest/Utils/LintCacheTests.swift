@testable import IBLinterKit
import XCTest

class LintCacheTests: XCTestCase {

    func testLoadDiskCache() throws {
        class MockFileManager: CacheFileManager {
            let fixture = Fixture()
            var cacheDir: URL {
                return URL(fileURLWithPath: NSTemporaryDirectory())
            }
            func modificationDate(for path: String) -> Date? {
                return Date(timeIntervalSinceReferenceDate: 0.0)
            }

            func createCacheDirectory() throws {}
        }
        let config = Config()
        let mockFileManager = MockFileManager()
        let cache = try LintDiskCache.new(with: mockFileManager, config: config)
        let testFilePath = URL(fileURLWithPath: "/foo/bar/TestView.xib")
        XCTAssertNil(cache.violations(for: testFilePath))

        let violation = Violation(pathString: testFilePath.path, message: "Warning message", level: .warning)
        cache.insertCache(for: testFilePath, violations: [violation])
        try cache.save()

        let restoredCache = try LintDiskCache.load(with: mockFileManager, config: config)
        let restoredViolations = restoredCache.violations(for: testFilePath)
        XCTAssertEqual(restoredViolations?.count, 1)
        XCTAssertEqual(restoredViolations?[0].level, .warning)
        XCTAssertEqual(restoredViolations?[0].message, "Warning message")
    }
}
