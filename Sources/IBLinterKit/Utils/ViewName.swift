import Foundation
import IBDecodable

func viewName(of view: ViewProtocol) -> String {
    switch view {
    case let identifiable as IBIdentifiable:
        return "\(view.customClass ?? view.elementClass) (\(identifiable.id))"
    default:
        return view.customClass ?? view.elementClass
    }
}
