//
//  Error.swift
//  IBLinter
//
//  Created by Yuta Saito on 2018/09/01.
//

import PathKit

enum IBLinterError: Swift.Error {
    case dylibNotFound(potentialFolders: [Path])
    case packageManagerFailed(Error)
    case buildFailed(status: Int32, output: String)
    case readConfigFailed(Error)

    var localizedDescription: String {
        switch self {
        case let .dylibNotFound(potentialFolders):
            return "Could not find a libIBLinter to link against at any of: \(potentialFolders)"
        default:
            return String(describing: self)
        }
    }
}
