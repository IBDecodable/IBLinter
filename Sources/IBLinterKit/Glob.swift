import Foundation

public protocol GlobFileManager {
    func subpathsOfDirectory(atPath path: String) throws -> [String]
    func isDirectory(_ url: String) -> Bool
}

extension FileManager: GlobFileManager {}

extension FileManager {
    public func isDirectory(_ url: String) -> Bool {
        var isDirectory: ObjCBool = false
        if fileExists(atPath: url, isDirectory: &isDirectory) {
            return isDirectory.boolValue
        } else {
            return false
        }
    }
}


#if os(Linux)
import Glibc

let system_glob = Glibc.glob
#else
import Darwin

let system_glob = Darwin.glob
#endif

public class Glob {
    let fileManager: GlobFileManager
    init(fileManager: GlobFileManager) {
        self.fileManager = fileManager
    }

    private let globFlags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
    public func glob(pattern: String) -> Set<URL> {
        var gt = glob_t.init()
        defer { globfree(&gt) }

        let patterns = expandRecursiveStars(pattern: pattern)
        var results: [String] = []

        for pattern in patterns {
            if executeGlob(pattern: pattern, gt: &gt) {
                #if os(Linux)
                let matchCount = Int(gt.gl_pathc)
                #else
                let matchCount = Int(gt.gl_matchc)
                #endif
                for i in 0..<matchCount {
                    let path = String.init(cString: gt.gl_pathv[i]!)
                    results.append(path)
                }
            }
        }
        return Set(results.map(URL.init(fileURLWithPath: )))
    }

    private func executeGlob(pattern: UnsafePointer<CChar>, gt: UnsafeMutablePointer<glob_t>) -> Bool {
        return 0 == system_glob(pattern, globFlags, nil, gt)
    }

    func expandRecursiveStars(pattern: String) -> Set<String> {
        func splitFirstStar(pattern: String) -> (head: String, tail: String?)? {
            let components = pattern.components(separatedBy: "**")
            guard let head = components.first, !head.isEmpty else { return nil }
            let tailComponents = components.dropFirst()
            guard !tailComponents.isEmpty else { return (head, nil) }
            var tail = tailComponents.joined(separator: "**")
            tail = tail.first == "/" ? String(tail.dropFirst()) : tail
            return (head, tail)

        }
        guard let (head, tail) = splitFirstStar(pattern: pattern) else { return [] }
        func recursiveChildren(current: String) -> [String] {
            do {
                return try fileManager.subpathsOfDirectory(atPath: current)
                    .compactMap {
                        let path = URL(fileURLWithPath: current).appendingPathComponent($0).path
                        guard fileManager.isDirectory(path) else { return nil }
                        return path
                    }
                    .flatMap { recursiveChildren(current: $0) } + [current]
            } catch {
                return []
            }
        }
        guard let tailComponent = tail else { return [head] }
        guard !tailComponent.isEmpty else {
            if fileManager.isDirectory(head) {
                return [URL(fileURLWithPath: head).appendingPathComponent("*").path]
            } else {
                return []
            }
        }
        let children = recursiveChildren(current: head)
        let result = children.map { URL(fileURLWithPath: $0).appendingPathComponent(tailComponent).path }
            .flatMap { expandRecursiveStars(pattern: $0) }
        return Set(result)
    }
}

@available(*, deprecated)
func expandGlobstar(pattern: String, fileManager: GlobFileManager = FileManager.default) -> Set<String> {
    return Glob(fileManager: fileManager).expandRecursiveStars(pattern: pattern)
}

public func glob(pattern: String, fileManager: GlobFileManager = FileManager.default) -> Set<URL> {
    return Glob(fileManager: fileManager).glob(pattern: pattern)
}
