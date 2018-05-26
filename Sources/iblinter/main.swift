import IBLinterKit
import PathKit

let iblinterFile = Path("./IBLinterFile.swift")

if iblinterFile.exists {
    IBLinterRunner(ibLinterFile: iblinterFile).run()
} else {
    let app = IBLinter()
    app.run()
}
