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
    var defaultCacheDir: URL { get }
    func modificationDate(for path: String) -> Date?
    func createDirectory(at path: URL) throws
}

extension FileManager: CacheFileManager {
    var defaultCacheDir: URL {
        return urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("IBLinter/\(Version.current.value)")
    }

    func modificationDate(for path: String) -> Date? {
        return (try? attributesOfItem(atPath: path))?[.modificationDate] as? Date
    }

    func createDirectory(at path: URL) throws {
        try createDirectory(at: path, withIntermediateDirectories: true, attributes: nil)
    }
}

public class LintDiskCache: LintCache {
    var content: LintCacheContent
    let fileManager: CacheFileManager
    let configHashKey: String
    let cacheDir: URL

    fileprivate init(content: LintCacheContent, fileManager: CacheFileManager,
                     configHashKey: String, cacheDir: URL) {
        self.content = content
        self.fileManager = fileManager
        self.configHashKey = configHashKey
        self.cacheDir = cacheDir
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

    static func deriveCacheDir(from config: Config, fileManager: CacheFileManager) -> URL {
        return config.cachePath.flatMap { URL(fileURLWithPath: $0) } ?? fileManager.defaultCacheDir
    }

    static func new(with fileManager: CacheFileManager, config: Config) throws -> LintCache {
        let emptyContent = LintCacheContent(entries: [:])
        let hashKey = try cacheHashKey(for: config)
        return LintDiskCache(content: emptyContent, fileManager: fileManager, configHashKey: hashKey,
                             cacheDir: Self.deriveCacheDir(from: config, fileManager: fileManager))
    }

    static func load(with fileManager: CacheFileManager, config: Config) throws -> LintCache {
        let hashKey = try cacheHashKey(for: config)
        let cacheDir = Self.deriveCacheDir(from: config, fileManager: fileManager)
        let cacheFilePath = cacheDir.appendingPathComponent(hashKey)
        let cacheFileContent = try Data(contentsOf: cacheFilePath)
        let content = try JSONDecoder().decode(LintCacheContent.self, from: cacheFileContent)
        return LintDiskCache(
          content: content, fileManager: fileManager,
          configHashKey: hashKey,
          cacheDir: cacheDir
        )
    }

    private static func cacheHashKey(for config: Config) throws -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let configContent = try encoder.encode(config)
        let hashKey = configContent.sha1().base64EncodedString()
        return hashKey.replacingOccurrences(of: "/", with: "_")
    }

    public func save() throws {
        let cacheFilePath = cacheDir.appendingPathComponent(configHashKey)
        let contentData = try JSONEncoder().encode(content)
        try fileManager.createDirectory(at: cacheDir)
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
