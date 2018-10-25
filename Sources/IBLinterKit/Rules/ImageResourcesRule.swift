//
//  ImageResourcesRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/11.
//

import Foundation
import IBDecodable
import xcproj

extension Rules {

    struct ImageResourcesRule: Rule {

        static let identifier: String = "image_resources"

        let assetsCatalogs: [AssetsCatalog]
        let xcodeproj: [XcodeProj]

        public init(context: Context) {
            let paths = glob(pattern: context.workDirectory.appendingPathComponent("**/*.xcassets").path)
            let excluded = context.config.excluded.flatMap { glob(pattern: "\($0)/**/*.xcassets") }
            let lintablePaths = paths.filter { !excluded.map { $0.absoluteString }.contains($0.absoluteString) }
            self.init(catalogs: lintablePaths.map { AssetsCatalog.init(path: $0.relativePath) })
        }

        init(catalogs: [AssetsCatalog]) {
            self.assetsCatalogs = catalogs
            self.xcodeproj = glob(pattern: "*.xcodeproj").compactMap {
                try? XcodeProj.init(pathString: $0.path)
            }
        }

        func validate(xib: XibFile) -> [Violation] {
            return validate(
                for: xib.document.children(of: Image.self),
                imageViews: xib.document.children(of: ImageView.self),
                file: xib
            )
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            return validate(
                for: storyboard.document.children(of: Image.self),
                imageViews: storyboard.document.children(of: ImageView.self),
                file: storyboard
            )
        }

        private func validate<T: InterfaceBuilderFile>(for images: [Image], imageViews: [ImageView], file: T) -> [Violation] {
            let catalogAssetNames = assetsCatalogs.flatMap { $0.values }
            let xcodeprojAssetNames = xcodeproj.flatMap {
                $0.pbxproj.objects.fileReferences.compactMap {
                    $0.value.name
                }
            }
            let assetNames = catalogAssetNames + xcodeprojAssetNames
            return Set(imageViews.compactMap { $0.image } + images.map { $0.name })
                .filter { !assetNames.contains($0) }
                .map {
                    Violation(
                        pathString: file.pathString,
                        message: "\($0) not found",
                        level: .error)
                }
        }
    }
}

private extension AssetsCatalog {
    // namespaced names of the
    var values: [String] {
        return entries.flatMap { $0.values }
    }
}

private extension AssetsCatalog.Entry {
    var values: [String] {
        switch self {
        case .group(_, let items):
            return items.flatMap { $0.values }
        case .color(_, let value):
            return [value]
        case .image(_, let value):
            return [value]
        }
    }
}
