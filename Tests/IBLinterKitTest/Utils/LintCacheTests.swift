@testable import IBLinterKit
import XCTest

class LintCacheTests: XCTestCase {
    class MockFileManager: CacheFileManager {
        let fixture = Fixture()
        lazy var defaultCacheDir = makeTemporalyDirectory()
        func modificationDate(for path: String) -> Date? {
            return Date(timeIntervalSinceReferenceDate: 0.0)
        }

        func createDirectory(at path: URL) throws {
            try FileManager.default.createDirectory(at: path)
        }
    }

    func testCacheDirOption() throws {
        let tmpDir = makeTemporalyDirectory()
        let overrideCacheDir = tmpDir.appendingPathComponent("override")
        let config = Config(cachePath: overrideCacheDir.path)
        let fileManager = MockFileManager()
        fileManager.defaultCacheDir = tmpDir.appendingPathComponent("default")
        let cacheDir = LintDiskCache.deriveCacheDir(from: config, fileManager: fileManager)
        XCTAssertEqual(cacheDir, overrideCacheDir)

        let cache = try LintDiskCache.new(with: fileManager, config: config)
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: fileManager.defaultCacheDir.path)
        )
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: overrideCacheDir.path)
        )
        try cache.save()
        XCTAssertFalse(
            FileManager.default.fileExists(atPath: fileManager.defaultCacheDir.path)
        )
        XCTAssertTrue(
            FileManager.default.fileExists(atPath: overrideCacheDir.path)
        )
    }

    func testLoadDiskCache() throws {
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

func makeTemporalyDirectory() -> URL {
    let tempdir = URL(fileURLWithPath: NSTemporaryDirectory())
    let templatePath = tempdir.appendingPathComponent("iblinter.XXXXXX")
    var template = [UInt8](templatePath.path.utf8).map({ Int8($0) }) + [Int8(0)]
    if mkdtemp(&template) == nil {
        fatalError("Failed to create temp directory")
    }
    return URL(fileURLWithPath: String(cString: template))
}
