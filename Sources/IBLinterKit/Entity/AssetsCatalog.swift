//
//  AssetsCatalog.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2018/05/11.
//

import Foundation

struct AssetsCatalog {
    let name: String
    let entries: [Entry]

    init(path: String) {
        name = path.lastComponentWithoutExtension
        entries = type(of: self).process(folder: path)
    }
}

extension AssetsCatalog {

    static func process(folder: String, withPrefix prefix: String = "") -> [AssetsCatalog.Entry] {
        return (try? FileManager.default.contentsOfDirectory(atPath: folder).sorted(by: <)
            .map { URL(fileURLWithPath: folder).appendingPathComponent($0) }
            .compactMap {
            AssetsCatalog.Entry(path: $0.path, withPrefix: prefix)
            }) ?? []
    }

    private enum Constants {
        static let path: String = "Contents.json"
        static let properties: String = "properties"
        static let providesNamespace: String = "provides-namespace"

        enum Item: String {
            case colorSet = "colorset"
            case imageSet = "imageset"
        }
    }

    enum Entry: Equatable {
        case group(name: String, items: [Entry])
        case color(name: String, value: String)
        case image(name: String, value: String)

        init?(path: String, withPrefix prefix: String) {
            guard FileManager.default.isDirectory(path) else { return nil }
            let type: String = path.extension ?? ""

            switch Constants.Item(rawValue: type) {
            case .colorSet?:
                let name: String = path.lastComponentWithoutExtension
                self = .color(name: name, value: "\(prefix)\(name)")
            case .imageSet?:
                let name: String = path.lastComponentWithoutExtension
                self = .image(name: name, value: "\(prefix)\(name)")
            case nil:
                guard type.isEmpty else { return nil }
                let filename: String = path.lastComponent
                let subPrefix: String = AssetsCatalog.Entry.isNamespaced(path: path) ? "\(prefix)\(filename)/" : prefix

                self = .group(
                    name: filename,
                    items: AssetsCatalog.process(folder: path, withPrefix: subPrefix)
                )
            }
        }

        private static func isNamespaced(path: String) -> Bool {
            let metadata: [String : Any] = self.metadata(for: path)

            if let properties = metadata[Constants.properties] as? [String: Any],
                let providesNamespace = properties[Constants.providesNamespace] as? Bool {
                return providesNamespace
            } else {
                return false
            }
        }

        private static func metadata(for path: String) -> [String: Any] {
            let contentsFile: URL = URL(fileURLWithPath: path).appendingPathComponent(Constants.path)

            guard let data = try? Data.init(contentsOf: contentsFile),
                let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
                    return [:]
            }

            return (json as? [String: Any]) ?? [:]
        }
    }
}

private extension String {
    var lastComponent: String {
        return NSString(string: self).lastPathComponent
    }

    var lastComponentWithoutExtension: String {
        return NSString(string: lastComponent).deletingPathExtension
    }

    var `extension`: String? {
        let pathExtension = NSString(string: self).pathExtension
        if  pathExtension.isEmpty {
            return nil
        }

        return pathExtension
    }
}
