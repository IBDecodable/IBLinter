import Foundation
import IBDecodable

extension Rules {

    struct ColorResourcesRule: Rule {

        static let identifier = "color_resources"
        static let description = "Check if named color resources are valid."

        let assetsCatalogs: [AssetsCatalog]

        public init(context: Context) {
            let paths = glob(pattern: context.workDirectory.appendingPathComponent("**/*.xcassets").path)
            let excluded = context.config.excluded.flatMap { glob(pattern: "\($0)/**/*.xcassets") }
            let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
            self.init(catalogs: lintablePaths.map { AssetsCatalog.init(path: $0.relativePath) })
        }

        init(catalogs: [AssetsCatalog]) {
            self.assetsCatalogs = catalogs
        }

        func validate(xib: XibFile) -> [Violation] {
            return validate(
                for: xib.document.children(of: NamedColor.self),
                file: xib
            )
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            return validate(
                for: storyboard.document.children(of: NamedColor.self),
                file: storyboard
            )
        }

        private func validate<T: InterfaceBuilderFile>(for colors: [NamedColor], file: T) -> [Violation] {
            let catalogAssetNames = assetsCatalogs.flatMap { $0.entryValues(for: .colorSet) }
            return colors
                .map { $0.name }
                .filter { !catalogAssetNames.contains($0) }
                .map {
                    Violation(
                        pathString: file.pathString,
                        message: "\($0) not found",
                        level: .error)
            }
        }
    }
}
