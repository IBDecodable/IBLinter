//
//  DuplicateConstraintRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/23.
//

import Foundation
import IBDecodable

extension Rules {

    struct DuplicateConstraintRule: Rule {

        static let identifier: String = "duplicate_constraint"
        static let description: String = "Display warning when view has duplicated constraint."
        static let isDefault: Bool = true

        init(context: Context) {}

        func validate(storyboard: StoryboardFile) -> [Violation] {
            return storyboard.document.scenes?.compactMap { $0.viewController?.viewController.rootView }
                .flatMap { validate(for: $0, file: storyboard) } ?? []
        }

        func validate(xib: XibFile) -> [Violation] {
            return xib.document.views?.flatMap { validate(for: $0.view, file: xib)} ?? []
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            return duplicateConstraints(for: view.constraints ?? []).map {
                // swiftlint:disable:next line_length
                let message = "duplicate constraint \($0.id) (firstItem: \($0.firstItem ?? "nil") attribute: \($0.firstAttribute.map(String.init(describing: )) ?? "nil") secondItem: \($0.secondItem ?? "nil") attribute: \($0.secondAttribute.map(String.init(describing: )) ?? "nil"))"
                return Violation(
                    pathString: file.pathString,
                    message: message,
                    level: .warning)
            } + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }

        private func duplicateConstraints(for constraints: [Constraint]) -> [Constraint] {

            var duplicateConstraints: [Constraint] = []
            var uniqueConstraints: [Constraint] = []

            constraints.forEach { (constraint: Constraint) -> Void in
                if uniqueConstraints.contains(where: { equal(lhs: $0, rhs: constraint) }) {
                    duplicateConstraints.append(constraint)
                } else {
                    uniqueConstraints.append(constraint)
                }
            }
            return duplicateConstraints
        }

        private func equal(lhs: Constraint, rhs: Constraint) -> Bool {
            let sameItems: (Bool) = (lhs.firstItem == rhs.firstItem && lhs.secondItem == rhs.secondItem)
            let reverseItems: (Bool) = (lhs.firstItem == rhs.secondItem && lhs.secondItem == rhs.firstItem)
            let sameAttributes: (Bool) = (lhs.firstAttribute == rhs.firstAttribute && lhs.secondAttribute == rhs.secondAttribute)
            let reverseAttributes: (Bool) = (lhs.secondAttribute == rhs.firstAttribute && lhs.firstAttribute == rhs.secondAttribute)
            let sameConstant: Bool = lhs.constant == rhs.constant
            let reverseConstaint: Bool = lhs.constant == rhs.constant.map(-)
            let samePriority: Bool = lhs.priority == rhs.priority
            let sameRelation: Bool = lhs.relation == rhs.relation

            return (samePriority && sameRelation) && (sameItems && sameAttributes && sameConstant) ||
                    (reverseItems && reverseAttributes && reverseConstaint)
        }
    }
}
