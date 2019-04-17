extension String {
    func escapedForXML() -> String {
        // & needs to go first, otherwise other replacements will be replaced again
        let htmlEscapes: [(String, String)] = [
            ("&", "&amp;"),
            ("\"", "&quot;"),
            ("'", "&apos;"),
            (">", "&gt;"),
            ("<", "&lt;")
        ]
        var newString: String = self
        for (key, value) in htmlEscapes {
            newString = newString.replacingOccurrences(of: key, with: value)
        }
        return newString
    }
}
