import Foundation

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

private func expandGlobstar(pattern: String) -> [String] {
    guard pattern.contains("**") else {
        return [pattern]
    }

    var results = [String]()
    var parts = pattern.components(separatedBy: "**")
    let firstPart = parts.removeFirst()
    var lastPart = parts.joined(separator: "**")

    let fileManager = FileManager.default

    var directories: [String]

    do {
        directories = try fileManager.subpathsOfDirectory(atPath: firstPart).compactMap { subpath in
            let fullPath = NSString(string: firstPart).appendingPathComponent(subpath)
            guard fileManager.isDirectory(fullPath) else { return nil }
            return fullPath
        }
    } catch {
        directories = []
        print("Error parsing file system item: \(error)")
    }

    directories.insert(firstPart, at: 0)

    if lastPart.isEmpty {
        results.append(firstPart)
    }

    if lastPart.isEmpty {
        lastPart = "*"
    }
    for directory in directories {
        let partiallyResolvedPattern = NSString(string: directory).appendingPathComponent(lastPart)
        results.append(contentsOf: expandGlobstar(pattern: partiallyResolvedPattern))
    }

    return results
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
