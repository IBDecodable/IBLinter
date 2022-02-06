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
        
        private let excluded: [String]
        
        init(context: Context) {
            excluded = context.config.hidesBottomBarRule?.excludedViewControllers ?? []
        }
        
        func validate(xib: XibFile) -> [Violation] { return [] }
        
        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let viewControllers = scenes.compactMap { $0.viewController?.viewController }
            return viewControllers.compactMap { validate(for: $0, file: storyboard) }
        }
        
        private func validate<T: InterfaceBuilderFile>(for viewController: ViewControllerProtocol, file: T) -> Violation? {
            guard let customClass = viewController.customClass,
                  let hidesBottomBar = viewController.hidesBottomBarWhenPushed,
                  !excluded.contains(where: { $0 == customClass }) else {
                return nil
            }
            let message = "\(customClass).hidesBottomBarWhenPushed is not enabled."
            return hidesBottomBar ? nil : Violation(pathString: file.pathString, message: message, level: .error)
        }
    }
}
