import Foundation

struct GitLabJUnitReporter: Reporter {

    static let identifier = "gitlab"

    static func generateReport(violations: [Violation]) -> String {
        return "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<testsuites><testsuite>" +
            violations.map({ violation -> String in
                let fileName = violation.pathString.replacingOccurrences(of: FileManager.default.currentDirectoryPath + "/", with: "").escapedForXML()

                let severity = violation.level.rawValue
                let reason = violation.message.escapedForXML()

                let message = "\(severity): in \(fileName)"
                let body = """
                Severity: \(severity)
                Reason: \(reason)

                File: \(fileName)
                """
                return [
                    "\n\t<testcase name='\(message)\'>\n",
                    "\t\t<failure>\(body)\n\t\t</failure>\n",
                    "\t</testcase>"
                    ].joined()
            }).joined() + "\n</testsuite></testsuites>\n"
    }
}
