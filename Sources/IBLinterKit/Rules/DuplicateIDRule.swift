//
//  DuplicateIDRule.swift
//  IBLinterKit
//
//  Created by Eric Marchand on 2019/10/29.
//

import Foundation
import IBDecodable

extension Rules {

    struct DuplicateIDRule: Rule {

        static let identifier = "duplicate_id"
        static let description = "Display warning when elements use same id."
        static let isDefault = true

        init(context: Context) {}

        func validate(storyboard: StoryboardFile) -> [Violation] {
            return validate(file: storyboard, in: storyboard.document)
        }

        func validate(xib: XibFile) -> [Violation] {
            return validate(file: xib, in: xib.document)
        }

        private func validate<T: InterfaceBuilderFile>(file: T, in document: IBElement) -> [Violation] {
            return duplicateIds(in: document).map {
                let message = "duplicate element id \($0.0)"
                return Violation(
                    pathString: file.pathString,
                    message: message,
                    level: .warning)
            }
        }

        private func duplicateIds(in document: IBElement) -> [(String, [IBIdentifiable])] {
            var byId: [String: [IBIdentifiable]] = [:]
            var duplicateId: [String] = []
            _ = document.browse { element in
                if let identifiable = element as? IBIdentifiable {
                    if var arrayForId = byId[identifiable.id] {
                        duplicateId.append(identifiable.id)
                        arrayForId.append(identifiable)
                        byId[identifiable.id] = arrayForId
                    } else {
                        byId[identifiable.id] = [identifiable]
                    }
                }
                return true
            }
            return duplicateId.map { ($0, byId[$0] ?? []) }
        }
    }
}
