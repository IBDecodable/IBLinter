import Foundation

public struct LintCacheContent: Codable {
    public typealias FilePath = String
    public struct Entry: Codable {
        public var modificationDate: Date
        public var violations: [Violation]
    }
    public var entries: [FilePath: Entry]
}

public protocol LintCache {
    func violations(for fileURL: URL) -> [Violation]?
    func insertCache(for fileURL: URL, violations: [Violation])
    func save() throws
}

struct LintEmptyCache: LintCache {
    func violations(for fileURL: URL) -> [Violation]? { return nil }
    func insertCache(for fileURL: URL, violations: [Violation]) {}
    func save() throws {}
}

protocol CacheFileManager {
    var cacheDir: URL { get }
    func modificationDate(for path: String) -> Date?
    func createCacheDirectory() throws
}

extension FileManager: CacheFileManager {
    var cacheDir: URL {
        return urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("IBLinter/\(Version.current.value)")
    }

    func modificationDate(for path: String) -> Date? {
        return (try? attributesOfItem(atPath: path))?[.modificationDate] as? Date
    }

    func createCacheDirectory() throws {
        try createDirectory(at: cacheDir, withIntermediateDirectories: true, attributes: nil)
    }
}

public class LintDiskCache: LintCache {
    var content: LintCacheContent
    let fileManager: CacheFileManager
    let configHashKey: String

    fileprivate init(content: LintCacheContent, fileManager: CacheFileManager, configHashKey: String) {
        self.content = content
        self.fileManager = fileManager
        self.configHashKey = configHashKey
    }

    public func insertCache(for fileURL: URL, violations: [Violation]) {
        guard let modificationDate = fileManager.modificationDate(for: fileURL.path) else { return }
        content.entries[fileURL.absoluteURL.path] = LintCacheContent.Entry(
            modificationDate: modificationDate, violations: violations
        )
    }

    public func violations(for fileURL: URL) -> [Violation]? {
        guard let entry = content.entries[fileURL.absoluteURL.path],
            fileManager.modificationDate(for: fileURL.path) == entry.modificationDate else {
            return nil
        }
        return entry.violations
    }
}

extension LintDiskCache {

    static func new(with fileManager: CacheFileManager, config: Config) throws -> LintCache {
        let emptyContent = LintCacheContent(entries: [:])
        let hashKey = try cacheHashKey(for: config)
        return LintDiskCache(content: emptyContent, fileManager: fileManager, configHashKey: hashKey)
    }

    static func load(with fileManager: CacheFileManager, config: Config) throws -> LintCache {
        let hashKey = try cacheHashKey(for: config)
        let cacheFilePath = fileManager.cacheDir.appendingPathComponent(hashKey)
        let cacheFileContent = try Data(contentsOf: cacheFilePath)
        let content = try JSONDecoder().decode(LintCacheContent.self, from: cacheFileContent)
        return LintDiskCache(content: content, fileManager: fileManager, configHashKey: hashKey)
    }

    private static func cacheHashKey(for config: Config) throws -> String {
        let configContent = try JSONEncoder().encode(config)
        let hashKey = configContent.sha1().base64EncodedString()
        return hashKey.replacingOccurrences(of: "/", with: "_")
    }

    public func save() throws {
        let cacheFilePath = fileManager.cacheDir.appendingPathComponent(configHashKey)
        let contentData = try JSONEncoder().encode(content)
        try fileManager.createCacheDirectory()
        try contentData.write(to: cacheFilePath)
    }
}

#if os(Linux)
import Crypto
#else
import CommonCrypto
extension Data {
    func sha1_legacy() -> Data {
        return withUnsafeBytes { [count] ptr in
            var hash = [UInt8](repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
            if let bytes = ptr.baseAddress?.assumingMemoryBound(to: UInt8.self) {
                CC_SHA1(bytes, CC_LONG(count), &hash)
            }
            return Data(hash)
        }
    }
}
#endif

private extension Data {
    func sha1() -> Data {
        #if os(Linux)
        return Data(Insecure.SHA1.hash(data: self))
        #else
        return sha1_legacy()
        #endif
    }
}
