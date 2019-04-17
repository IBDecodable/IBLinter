struct CheckstyleReporter: Reporter {
    public static let identifier: String = "checkstyle"
    public static let isRealtime: Bool = false

    public var description: String {
        return "Reports violations as Checkstyle XML."
    }

    public static func generateReport(violations: [Violation]) -> String {
        return [
            "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<checkstyle version=\"4.3\">",
            violations
                .group(by: { ($0.pathString).escapedForXML() })
                .sorted(by: { $0.key < $1.key })
                .map(generateForViolationFile).joined(),
            "\n</checkstyle>"
        ].joined()
    }

    private static func generateForViolationFile(_ file: String, violations: [Violation]) -> String {
        return [
            "\n\t<file name=\"", file, "\">\n",
            violations.map(generateForSingleViolation).joined(),
            "\t</file>"
        ].joined()
    }

    private static func generateForSingleViolation(violation: Violation) -> String {
        let severity: String = violation.level.rawValue
        let reason: String = violation.message.escapedForXML()
        return [
            "\t\t<error severity=\"", severity, "\" ",
            "message=\"", reason, "\"/>\n"
        ].joined()
    }
}
