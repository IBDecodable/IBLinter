import Foundation

protocol GlobFileManager {
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

class Glob {
    let fileManager: GlobFileManager
    init(fileManager: GlobFileManager) {
        self.fileManager = fileManager
    }

    func expandRecursiveStars(pattern: String) -> [String] {
        func splitFirstStar(pattern: String) -> (head: String, tail: String?)? {
            let components = pattern.components(separatedBy: "**")
            guard let head = components.first, !head.isEmpty else { return nil }
            let tailComponents = components.dropFirst()
            guard !tailComponents.isEmpty else { return (head, nil) }
            var tail = tailComponents.joined(separator: "**")
            tail = tail.first == "/" ? String(tail.dropFirst()) : tail
            return (head, tail.isEmpty ? nil : tail)

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
        guard let tailComponent = tail else {
            if fileManager.isDirectory(head) {
                return [URL(fileURLWithPath: head).appendingPathComponent("*").path]
            } else {
                return []
            }
        }
        let children = recursiveChildren(current: head)
        return children.map { URL(fileURLWithPath: $0).appendingPathComponent(tailComponent).path }
            .flatMap { expandRecursiveStars(pattern: $0) }
    }
}

@available(*, deprecated)
func expandGlobstar(pattern: String, fileManager: GlobFileManager = FileManager.default) -> [String] {
    return Glob(fileManager: fileManager).expandRecursiveStars(pattern: pattern)
}

private let globFlags = GLOB_TILDE | GLOB_BRACE | GLOB_MARK
public func glob(pattern: String) -> [URL] {
    var gt = glob_t.init()
    defer { globfree(&gt) }

    let patterns = expandGlobstar(pattern: pattern)
    var results: [String] = []

    for pattern in patterns {
        if executeGlob(pattern: pattern, gt: &gt) {
            let matchCount = Int(gt.gl_matchc)
            for i in 0..<matchCount {
                let path = String.init(cString: gt.gl_pathv[i]!)
                results.append(path)
            }
        }
    }
    return results.map(URL.init(fileURLWithPath: ))
}

private func executeGlob(pattern: UnsafePointer<CChar>, gt: UnsafeMutablePointer<glob_t>) -> Bool {
    return 0 == glob(pattern, globFlags, nil, gt)
}
