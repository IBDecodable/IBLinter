//
//  Fixture.swift
//  IBLinterKitTest
//
//  Created by Yuta Saito on 2019/03/30.
//

import Foundation

final class Fixture {
    let bundle = Bundle(for: Fixture.self)
    let testTargetPath = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .deletingLastPathComponent() // ./Tests/IBLinterKitTests

    func path(_ string: String) -> URL {
        #if SWIFT_PACKAGE
            return testTargetPath.appendingPathComponent(string)
        #else
            guard let bundleURL = bundle.resourceURL else {
                fatalError("\(string) not found")
            }
            return bundleURL.appendingPathComponent(string)
        #endif
    }
}
