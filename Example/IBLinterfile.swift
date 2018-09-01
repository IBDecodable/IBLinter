import IBLinter
import IBLinterKit
import IBDecodable

let linter = IBLinter()

struct FooRule: Rule {
    init(context: Context) {}

    static let identifier: String = "foo"

    func validate(storyboard: StoryboardFile) -> [Violation] {
        return []
    }

    func validate(xib: XibFile) -> [Violation] {
        if xib.fileName == "MyViewController.xib" {
            return [Violation(pathString: xib.pathString, message: "foo", level: .warning)]
        }
        return []
    }
}

linter.lint(externalRules: [FooRule.self])
