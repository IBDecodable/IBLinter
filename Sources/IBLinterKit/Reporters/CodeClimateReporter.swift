#if canImport(CryptoSwift)
import CryptoSwift
#endif
import Foundation
import SourceKittenFramework

struct CodeClimateReporter: Reporter {

    static let identifier = "codeclimate"

    static func generateReport(violations: [Violation]) -> String {
        return toJSON(violations.map(dictionary(for:)))
            .replacingOccurrences(of: "\\/", with: "/")
    }

    // MARK: - Private
    private static func dictionary(for violation: Violation) -> [String: Any] {
        let path = violation.pathString.replacingOccurrences(of: FileManager.default.currentDirectoryPath + "/", with: "")
        return [
            "check_name": "IBLinter",
            "description": violation.message,
            "engine_name": "IBLinter",
            "fingerprint": ["\(path)", "\(violation.message)"].joined().md5(),
            "location": [
                "path": path,
                "lines": [
                    "begin": 0 as Any,
                    "end": 0 as Any
                ]
            ],
            "severity": violation.level == .error ? "MAJOR": "MINOR",
            "type": "issue"
        ]
    }
}
