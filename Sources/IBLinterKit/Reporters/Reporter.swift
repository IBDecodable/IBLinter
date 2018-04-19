//
//  Reporter.swift
//  IBLinterKit
//
//  Created by SaitoYuta on 2017/12/11.
//

protocol Reporter {
    var identifier: String { get }

    func report(violations: [Violation])
}
