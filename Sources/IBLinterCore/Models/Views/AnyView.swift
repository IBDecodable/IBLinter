//
//  AnyView.swift
//  IBLinterCore
//
//  Created by Steven Deutsch on 3/11/18.
//

import SWXMLHash

// MARK: - ViewProtocol

public protocol ViewProtocol {
    var elementClass: String { get }
    var id: String { get }

    var autoresizingMask: AutoresizingMask? { get }
    var clipsSubviews: Bool? { get }
    var constraints: [Constraint]? { get }
    var contentMode: String? { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var misplaced: Bool? { get }
    var opaque: Bool? { get }
    var rect: Rect { get }
    var subviews: [AnyView]? { get }
    var translatesAutoresizingMaskIntoConstraints: Bool? { get }
    var userInteractionEnabled: Bool? { get }

}

// MARK: - AnyView

public struct AnyView: XMLDecodable, HasAutomaticCodingKeys {

    public let view: ViewProtocol

    init(_ view: ViewProtocol) {
        self.view = view
    }

    static func decode(_ xml: XMLIndexer) throws -> AnyView {
        guard let elementName = xml.element?.name else {
            throw IBError.elementNotFound
        }
        switch elementName {
        case "button":                   return try AnyView(Button.decode(xml))
        case "collectionView":           return try AnyView(CollectionView.decode(xml))
        case "collectionViewCell":       return try AnyView(CollectionViewCell.decode(xml))
        case "imageView":                return try AnyView(ImageView.decode(xml))
        case "label":                    return try AnyView(Label.decode(xml))
        case "pickerView":               return try AnyView(PickerView.decode(xml))
        case "scrollView":               return try AnyView(ScrollView.decode(xml))
        case "segmentedControl":         return try AnyView(SegmentedControl.decode(xml))
        case "stackView":                return try AnyView(StackView.decode(xml))
        case "switch":                   return try AnyView(Switch.decode(xml))
        case "tableView":                return try AnyView(TableView.decode(xml))
        case "tableViewCell":            return try AnyView(TableViewCell.decode(xml))
        case "tableViewCellContentView": return try AnyView(TableViewCell.TableViewContentView.decode(xml))
        case "textField":                return try AnyView(TextField.decode(xml))
        case "textView":                 return try AnyView(TextView.decode(xml))
        case "toolbar":                  return try AnyView(Toolbar.decode(xml))
        case "view":                     return try AnyView(View.decode(xml))
        default:
            throw IBError.unsupportedViewClass(elementName)
        }
    }

    public func encode(to encoder: Encoder) throws { fatalError() }
}

// MARK: - Rect

public struct Rect: XMLDecodable, HasAutomaticCodingKeys {
    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float

    static func decode(_ xml: XMLIndexer) throws -> Rect {
        let container = xml.container(for: self.self, keys: CodingKeys.self)
        return try Rect.init(
            x:      container.attribute(of: .x),
            y:      container.attribute(of: .y),
            width:  container.attribute(of: .width),
            height: container.attribute(of: .height)
        )
    }
}

// MARK: - AutoresizingMask

public struct AutoresizingMask: XMLDecodable, HasAutomaticCodingKeys {
    public let widthSizable: Bool
    public let heightSizable: Bool

    static func decode(_ xml: XMLIndexer) throws -> AutoresizingMask {
        let container = xml.container(for: self.self, keys: CodingKeys.self)

        return try AutoresizingMask.init(
            widthSizable:  container.attribute(of: .widthSizable),
            heightSizable: container.attribute(of: .heightSizable)
        )
    }
}

// MARK: - Constraint

public struct Constraint: XMLDecodable, HasAutomaticCodingKeys {
    public let id: String
    public let constant: Int?
    public let multiplier: String?
    public let firstItem: String?
    public let firstAttribute: LayoutAttribute?
    public let secondItem: String?
    public let secondAttribute: LayoutAttribute?

    public enum LayoutAttribute: XMLAttributeDecodable, Equatable, HasAutomaticCodingKeys {
        case left, right, top, bottom, leading, trailing,
        width, height, centerX, centerY

        case leftMargin, rightMargin, topMargin,
        bottomMargin, leadingMargin, trailingMargin

        case other(String)

        static func decode(_ attribute: XMLAttribute) throws -> Constraint.LayoutAttribute {
            switch attribute.text {
            case "left":           return .left
            case "right":          return .right
            case "top":            return .top
            case "bottom":         return .bottom
            case "leading":        return .leading
            case "trailing":       return .trailing
            case "width":          return .width
            case "height":         return .height
            case "centerX":        return .centerX
            case "centerY":        return .centerY
            case "leftMargin":     return .leftMargin
            case "rightMargin":    return .rightMargin
            case "topMargin":      return .topMargin
            case "bottomMargin":   return .bottomMargin
            case "leadingMargin":  return .leadingMargin
            case "trailingMargin": return .trailingMargin
            default:               return .other(attribute.text)
            }
        }

        public static func ==(lhs: LayoutAttribute, rhs: LayoutAttribute) -> Bool {
            switch (lhs, rhs) {
            case (.left, .left), (.right, .right), (.top, .top), (.bottom, .bottom),
                 (.leading, .leading), (.trailing, .trailing), (.width, .width),
                 (.height, height), (.centerX, .centerX), (.centerY, .centerY),
                 (.leftMargin, .leftMargin), (.rightMargin, .rightMargin),
                 (.topMargin, .topMargin), (.bottomMargin, .bottomMargin),
                 (.leadingMargin, .leadingMargin), (.trailingMargin, .trailingMargin): return true
            case (.other(let msg1), .other(let msg2)): return msg1 == msg2
            default: return false
            }
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Constraint {
        let container = xml.container(for: self.self, keys: CodingKeys.self)

        return Constraint.init(
            id:              try container.attribute(of: .id),
            constant:        container.attributeIfPresent(of: .constant),
            multiplier:      container.attributeIfPresent(of: .multiplier),
            firstItem:       container.attributeIfPresent(of: .firstItem),
            firstAttribute:  container.attributeIfPresent(of: .firstAttribute),
            secondItem:      container.attributeIfPresent(of: .secondItem),
            secondAttribute: container.attributeIfPresent(of: .secondAttribute)
        )
    }
}

// MARK: - Color

public enum Color: XMLDecodable, HasAutomaticCodingKeys {
    public struct CalibratedWhite: XMLDecodable, HasAutomaticCodingKeys {
        public let key: String
        public let white: Float
        public let alpha: Float

        static func decode(_ xml: XMLIndexer) throws -> Color.CalibratedWhite {
            let container = xml.container(for: self.self, keys: CodingKeys.self)
            return try CalibratedWhite.init(
                key:   container.attribute(of: .key),
                white: container.attribute(of: .white),
                alpha: container.attribute(of: .alpha)
            )
        }
    }
    public struct SRGB: XMLDecodable, HasAutomaticCodingKeys {
        public let key: String
        public let red: Float
        public let blue: Float
        public let green: Float
        public let alpha: Float

        static func decode(_ xml: XMLIndexer) throws -> Color.SRGB {
            let container = xml.container(for: self.self, keys: CodingKeys.self)
            return try SRGB.init(
                key: container.attribute(of: .key),
                red: container.attribute(of: .red),
                blue: container.attribute(of: .blue),
                green: container.attribute(of: .green),
                alpha: container.attribute(of: .alpha)
            )
        }
    }
    case calibratedWhite(CalibratedWhite)
    case sRGB(SRGB)

    public var sRGB: SRGB? {
        switch self {
        case .sRGB(let sRGB):
            return sRGB
        default: return nil
        }
    }

    public var calibratedWhite: CalibratedWhite? {
        switch self {
        case .calibratedWhite(let calibratedWhite):
            return calibratedWhite
        default: return nil
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Color {
        let colorSpace: String = try xml.attributeValue(of: "colorSpace")
        switch colorSpace {
        case "calibratedWhite":
            return try .calibratedWhite(decodeValue(xml))
        case "custom":
            let customColorSpace: String = try xml.attributeValue(of: "customColorSpace")
            switch customColorSpace {
            case "sRGB":
                return try .sRGB(decodeValue(xml))
            default:
                throw IBError.unsupportedColorSpace(customColorSpace)
            }
        default:
            throw IBError.unsupportedColorSpace(colorSpace)
        }
    }

    public func encode(to encoder: Encoder) throws { fatalError() }
}
