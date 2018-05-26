import IBLinterKit
import PathKit

if Runtime.ibLinterfile.exists {
    IBLinterRunner(ibLinterfile: Runtime.ibLinterfile).run()
} else {
    let app = IBLinter()
    app.run()
}
