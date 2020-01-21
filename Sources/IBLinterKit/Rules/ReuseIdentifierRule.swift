import IBDecodable

extension Rules {
    
    struct ReuseIdentifierRule: Rule {
        
        static let identifier = "reuse_identifier"
        static let description = "Check that ReuseIdentifier same as class name."
        
        init(context: Context) {}
        
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
            let violation: [Violation] = {
                // Currently only supported TableViewCell and CollectionViewCell
                // UICollectionReusableView will be support after IBDecodable support its view.
                // MKAnnotationView is not yet supported by interfacebuilder.
                var reusableCells = [IBReusable & ViewProtocol]()
                if let tableView = view as? TableView, let cells = tableView.prototypeCells {
                    reusableCells += cells
                } else if let collectionView = view as? CollectionView, let cells = collectionView.cells {
                    reusableCells += cells
                } else if let cell = view as? IBReusable & ViewProtocol {
                    reusableCells += [cell]
                }
                
                return reusableCells.compactMap {
                    guard let customClass = $0.customClass else {
                        // don't violate if not have custom class for example Static cell type of table view.
                        return nil
                    }
                    if customClass != $0.reuseIdentifier {
                        let message = "\(viewName(of: $0)) should have the same Reuse Identifier"
                        return Violation(pathString: file.pathString, message: message, level: .warning)
                    }
                    return nil
                }
            }()
            return violation + (view.subviews?.flatMap { validate(for: $0.view, file: file) } ?? [])
        }
    }
}
