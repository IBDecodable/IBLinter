import IBDecodable

extension Rules {
    
    struct ReuseIdentifier: Rule {
        
        static let identifier = "reuse_identifier"
        static let description = "Check that ReuseIdentifier same as class name."
        
        init(context: Context) {}
        
        func validate(storyboard: StoryboardFile) -> [Violation] {
            guard let scenes = storyboard.document.scenes else { return [] }
            let views = scenes.compactMap { $0.viewController?.viewController.rootView }
            return views.flatMap { validate(for: $0, file: storyboard) }
        }
        
        func validate(xib: XibFile) -> [Violation] {
            // TODO: support Xib
            return []
        }
        
        private func validate<T: InterfaceBuilderFile>(for view: ViewProtocol, file: T) -> [Violation] {
            let violation: [Violation] = {
                func makeViolation(from view: ViewProtocol) -> Violation {
                    let message = "\(viewName(of: view)) should have the same reuseidentifier"
                    return Violation(pathString: file.pathString, message: message, level: .warning)
                }
                
                // Currently only supported TableViewCell and CollectionViewCell (contains UICollectionReusableView)
                if let tableView = view as? TableView {
                    return tableView.prototypeCells?.compactMap {
                        guard let customClass = $0.customClass, let reuseIdentifier = $0.reuseIdentifier else {
                            return makeViolation(from: $0)
                        }
                        if customClass != reuseIdentifier {
                            return makeViolation(from: $0)
                        }
                        return nil
                    } ?? []
                } else if let collectionView = view as? CollectionView {
                    return collectionView.cells?.compactMap {
                        guard let customClass = $0.customClass, let reuseIdentifier = $0.reuseIdentifier else {
                            return makeViolation(from: $0)
                        }
                        if customClass != reuseIdentifier {
                            return makeViolation(from: $0)
                        }
                        return nil
                    } ?? []
                } else {
                    return []
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
