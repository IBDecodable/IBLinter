//
//  ImageResourcesRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/11.
//

import Foundation
import IBDecodable
import XcodeProjKit

extension Rules {

    struct ImageResourcesRule: Rule {

        static let identifier = "image_resources"
        static let description = "Check if image resources are valid."

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
                try? XcodeProj(url: $0)
            }
        }

        func validate(xib: XibFile) -> [Violation] {
            return validate(
                for: xib.document.children(of: Image.self),
                imageViews: xib.document.children(of: ImageView.self),
                states: xib.document.children(of: Button.State.self),
                file: xib
            )
        }

        func validate(storyboard: StoryboardFile) -> [Violation] {
            return validate(
                for: storyboard.document.children(of: Image.self),
                imageViews: storyboard.document.children(of: ImageView.self),
                states: storyboard.document.children(of: Button.State.self),
                file: storyboard
            )
        }

        private func validate<T: InterfaceBuilderFile>(for images: [Image], imageViews: [ImageView], states: [Button.State], file: T) -> [Violation] {
            let catalogAssetNames = assetsCatalogs.flatMap { $0.entryValues(for: .imageSet, .symbolSet) }
            let xcodeprojAssetNames = xcodeproj.flatMap {
                $0.fileReferences.compactMap {
                    $0.name
                }
            }
            let imagesToCheck = images.filter { $0.catalog != "system" }.map { $0.name }
                + imageViews.filter { $0.catalog != "system" }.compactMap { $0.image }
                + states.filter { $0.catalog != "system" }.compactMap { $0.image }
            let assetNames = (catalogAssetNames + xcodeprojAssetNames)
            return Set(imagesToCheck)
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

extension XcodeProj {
    var fileReferences: [PBXFileReference] {
        return objects.dict.values.compactMap({ $0 as? PBXFileReference })
    }
}
