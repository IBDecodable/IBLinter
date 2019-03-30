@testable import IBLinterKit
import Foundation

extension Context {
    static func mock(from config: Config) -> Context {
        let workDirectory = URL(fileURLWithPath: #file)
            .deletingLastPathComponent() // ./Tests/IBLinterKitTests/Supports
            .deletingLastPathComponent() // ./Tests/IBLinterKitTests
            .deletingLastPathComponent() // ./Tests
            .deletingLastPathComponent() // ./
        return Context(
            config: config,
            workDirectory: workDirectory,
            externalRules: []
        )
    }
}

