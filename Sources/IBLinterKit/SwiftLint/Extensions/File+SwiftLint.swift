import Foundation
import SourceKittenFramework

extension File {

    internal func swiftDeclarationKindsByLine() -> [[SwiftDeclarationKind]]? {
        if sourcekitdFailed {
            return nil
        }
        var results = [[SwiftDeclarationKind]](repeating: [], count: lines.count + 1)
        var lineIterator = lines.makeIterator()
        var structureIterator = structure.kinds().makeIterator()
        var maybeLine = lineIterator.next()
        var maybeStructure = structureIterator.next()
        while let line = maybeLine, let structure = maybeStructure {
            if NSLocationInRange(structure.byteRange.location, line.byteRange),
               let swiftDeclarationKind = SwiftDeclarationKind(rawValue: structure.kind) {
                results[line.index].append(swiftDeclarationKind)
            }
            let lineEnd = NSMaxRange(line.byteRange)
            if structure.byteRange.location >= lineEnd {
                maybeLine = lineIterator.next()
            } else {
                maybeStructure = structureIterator.next()
            }
        }
        return results
    }

    internal func syntaxTokensByLine() -> [[SyntaxToken]]? {
        if sourcekitdFailed {
            return nil
        }
        var results = [[SyntaxToken]](repeating: [], count: lines.count + 1)
        var tokenGenerator = syntaxMap.tokens.makeIterator()
        var lineGenerator = lines.makeIterator()
        var maybeLine = lineGenerator.next()
        var maybeToken = tokenGenerator.next()
        while let line = maybeLine, let token = maybeToken {
            let tokenRange = NSRange(location: token.offset, length: token.length)
            if NSLocationInRange(token.offset, line.byteRange) ||
                NSLocationInRange(line.byteRange.location, tokenRange) {
                    results[line.index].append(token)
            }
            let tokenEnd = NSMaxRange(tokenRange)
            let lineEnd = NSMaxRange(line.byteRange)
            if tokenEnd < lineEnd {
                maybeToken = tokenGenerator.next()
            } else if tokenEnd > lineEnd {
                maybeLine = lineGenerator.next()
            } else {
                maybeLine = lineGenerator.next()
                maybeToken = tokenGenerator.next()
            }
        }
        return results
    }

    internal func syntaxKindsByLine() -> [[SyntaxKind]]? {
        guard !sourcekitdFailed, let tokens = syntaxTokensByLine() else {
            return nil
        }

        return tokens.map { $0.compactMap { SyntaxKind(rawValue: $0.type) } }
    }

}
