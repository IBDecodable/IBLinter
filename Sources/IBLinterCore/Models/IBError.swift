//
//  IBError.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 3/11/18.
//

import SWXMLHash

public enum IBError: Swift.Error, CustomStringConvertible {
    case elementNotFound
    case unsupportedViewClass(String)
    case unsupportedViewControllerClass(String)
    case unsupportedConstraint(String)
    case unsupportedTableViewDataMode(String)
    case unsupportedColorSpace(String)

    public var description: String {
        switch self {
        case .elementNotFound:
            return "element not found"
        case .unsupportedViewClass(let name):
            return "unsupported view class '\(name)'"
        case .unsupportedViewControllerClass(let name):
            return "unsupported viewController class '\(name)'"
        case .unsupportedConstraint(let body):
            return "unsupported constraint type '\(body)'"
        case .unsupportedTableViewDataMode(let name):
            return "unsupported dataMode '\(name)'"
        case .unsupportedColorSpace(let colorSpace):
            return "unsupported color space '\(colorSpace)'"
        }
    }
}
