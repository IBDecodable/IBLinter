//
//  DuplicateConstraintRule.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/23.
//

import Foundation
import IBLinterCore

extension Rules {

    public struct DuplicateConstraintRule: Rule {

        public static let identifier: String = "duplicate_constraint"

        public init() {}

        public func validate(storyboard: StoryboardFile, swiftParser: SwiftIBParser) -> [Violation] {
            return storyboard.document.scenes?.flatMap { $0.viewController?.rootView }
                .flatMap { validate(for: $0, file: storyboard) } ?? []
        }

        public func validate(xib: XibFile, swiftParser: SwiftIBParser) -> [Violation] {
            return xib.document.views?.flatMap { validate(for: $0, file: xib)} ?? []
        }

        private func validate(for view: ViewProtocol, file: FileProtocol) -> [Violation] {
            return duplicateConstraints(for: view.constraints ?? []).map {
                let message = "duplicate constraint \($0.id) (firstItem: \($0.firstItem ?? "nil") attribute: \($0.firstAttribute.map(String.init(describing: )) ?? "nil") secondItem: \($0.secondItem ?? "nil") attribute: \($0.secondAttribute.map(String.init(describing: )) ?? "nil"))"
                return Violation(
                    file: file,
                    message: message,
                    level: .warning)
            }
        }

        private typealias Constraint = InterfaceBuilderNode.View.Constraint

        private func duplicateConstraints(for constraints: [Constraint]) -> [Constraint] {

            var duplicateConstraints: [Constraint] = []
            var uniqueConstraints: [Constraint] = []

            constraints.forEach { constraint in
                if uniqueConstraints.contains(where: { equal(lhs: $0, rhs: constraint) }) {
                    duplicateConstraints.append(constraint)
                } else {
                    uniqueConstraints.append(constraint)
                }
            }
            return duplicateConstraints
        }

        private func equal(lhs: Constraint, rhs: Constraint) -> Bool {
            let sameItems = (lhs.firstItem == rhs.firstItem && lhs.secondItem == rhs.secondItem)
            let reverseItems = (lhs.firstItem == rhs.secondItem && lhs.secondItem == rhs.firstItem)
            let sameAttributes = (lhs.firstAttribute == rhs.firstAttribute && lhs.secondAttribute == rhs.secondAttribute)
            let reverseAttributes = (lhs.secondAttribute == rhs.firstAttribute && lhs.firstAttribute == rhs.secondAttribute)
            let sameConstant = lhs.constant == rhs.constant
            let reverseConstaint = lhs.constant == rhs.constant.map(-)

            return (sameItems && sameAttributes && sameConstant) || (reverseItems && reverseAttributes && reverseConstaint)
        }
    }
}
