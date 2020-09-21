import Foundation
import IBDecodable

extension Rules {

    struct StackViewBackgroundColorRule: Rule {

        static let identifier = "stackview_backgroundcolor"
        static let description = "Force to background color of stackview should be default."

        public init(context: Context) {}

        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }

        func validate(xib: XibFile) -> [Violation] {
            guard let views = xib.document.views else { return [] }
            return views.flatMap { validate(for: $0.view, file: xib) }
        }

        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            let violations: [Violation] = {
                guard let stackView = view as? StackView, stackView.backgroundColor != nil else {
                    return []
                }
                let message = "\(viewName(of: view)) should not have background color"
                return [Violation(pathString: file.pathString, message: message, level: .warning)]
            }()

            return violations + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
