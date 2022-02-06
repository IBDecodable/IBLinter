//
//  HidesBottomBarRule.swift
//  IBLinterKit
//
//  Created by ykkd on 2022/02/06.
//

import IBDecodable

extension Rules {

    struct HidesBottomBarRule: Rule {
        
        static var identifier = "hides_bottom_bar"
        static var description = "Check if hidesBottomBarWhenPushed is enabled"
        
        init(context: Context) {
            // TODO: implement
        }
        
        func validate(storyboard: StoryboardFile) -> [Violation] {
            // TODO: implement
            return []
        }
        
        func validate(xib: XibFile) -> [Violation] { return [] }
    }
}
