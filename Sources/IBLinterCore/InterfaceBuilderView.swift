//
//  InterfaceBuilderView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

import SWXMLHash

public protocol ViewProtocol {
    var elementClass: String { get }
    var id: String { get }

    var autoresizingMask: AutoresizingMask? { get }
    var clipsSubviews: Bool? { get }
    var constraints: [Constraint]? { get }
    var contentMode: String? { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var isMisplaced: Bool? { get }
    var opaque: Bool? { get }
    var rect: Rect { get }
    var subviews: [AnyView]? { get }
    var translatesAutoresizingMaskIntoConstraints: Bool? { get }
    var userInteractionEnabled: Bool? { get }

}

// MARK: - View

public struct View: XMLDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UIView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let viewLayoutGuide: LayoutGuide?

    static func decode(_ xml: XMLIndexer) throws -> View {
        return View.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            viewLayoutGuide:                           xml.byKey("viewLayoutGuide").flatMap(decodeValue)
        )
    }
}

// MARK: - StackView

public struct StackView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIStackView"

    public let alignment: String?
    public let autoresizingMask: AutoresizingMask?
    public let axis: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> StackView {
        return StackView.init(
            id:                                        try xml.attributeValue(of: "id"),
            alignment:                                 xml.attributeValue(of: "alignment"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            axis:                                      xml.attributeValue(of: "axis"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - Label

public struct Label: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UILabel"

    public let adjustsFontSizeToFit: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let baselineAdjustment: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let horizontalHuggingPriority: Int?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let text: String
    public let textAlignment: String?
    public let textColor: Color?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let verticalHuggingPriority: Int?


    static func decode(_ xml: XMLIndexer) throws -> Label {
        return Label.init(
            id:                                        try xml.attributeValue(of: "id"),
            adjustsFontSizeToFit:                      xml.attributeValue(of: "adjustsFontSizeToFit"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            baselineAdjustment:                        xml.attributeValue(of: "baselineAdjustment"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            horizontalHuggingPriority:                 xml.attributeValue(of: "horizontalHuggingPriority"),
            lineBreakMode:                             xml.attributeValue(of: "lineBreakMode"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            text:                                      try xml.attributeValue(of: "text"),
            textAlignment:                             xml.attributeValue(of: "textAlignment"),
            textColor:                                 xml.byKey("color").flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            verticalHuggingPriority:                   xml.attributeValue(of: "verticalHuggingPriority")
        )
    }

}

// MARK: - ImageView

public struct ImageView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIImageView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let image: String
    public let insetsLayoutMarginsFromSafeArea: Bool?
    public let isMisplaced: Bool?
    public let multipleTouchEnabled: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> ImageView {
        return ImageView.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            image:                                     try xml.attributeValue(of: "image"),
            insetsLayoutMarginsFromSafeArea:           xml.attributeValue(of: "insetsLayoutMarginsFromSafeArea"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            multipleTouchEnabled:                      xml.attributeValue(of: "multipleTouchEnabled"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - TableView

public struct TableView: XMLDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UITableView"

    public let alwaysBounceVertical: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let dataMode: DataMode?
    public let estimatedRowHeight: Float?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let rowHeight: Float?
    public let sectionFooterHeight: Float?
    public let sectionHeaderHeight: Float?
    public let separatorStyle: String?
    public let style: String?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public enum DataMode: XMLAttributeDecodable {
        case `static`, prototypes

        static func decode(_ attribute: XMLAttribute) throws -> TableView.DataMode {
            switch attribute.text {
            case "static":     return .static
            case "prototypes": return .prototypes
            default:
                throw IBError.unsupportedTableViewDataMode(attribute.text)
            }
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> TableView {
        return TableView.init(
            id:                                        try xml.attributeValue(of: "id"),
            alwaysBounceVertical:                      xml.attributeValue(of: "alwaysBounceVertical"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            dataMode:                                  xml.attributeValue(of: "dataMode"),
            estimatedRowHeight:                        xml.attributeValue(of: "estimatedRowHeight"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            rowHeight:                                 xml.attributeValue(of: "rowHeight"),
            sectionFooterHeight:                       xml.attributeValue(of: "sectionFooterHeight"),
            sectionHeaderHeight:                       xml.attributeValue(of: "sectionHeaderHeight"),
            separatorStyle:                            xml.attributeValue(of: "separatorStyle"),
            style:                                     xml.attributeValue(of: "style"),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

public struct AnyView: XMLDecodable {

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

}

// MARK: - TableViewCell

public struct TableViewCell: XMLDecodable, ViewProtocol {

    public let id: String
    public let elementClass: String = "UITableView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: TableViewContentView
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    private let _subviews: [AnyView]?
    public var subviews: [AnyView]? {
        return (_subviews ?? []) + [AnyView(contentView)]
    }
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct TableViewContentView: XMLDecodable, ViewProtocol {
        public let id: String
        public let elementClass: String = "UITableViewContentView"

        public let autoresizingMask: AutoresizingMask?
        public let clipsSubviews: Bool?
        public let constraints: [Constraint]?
        public let contentMode: String?
        public let customClass: String?
        public let customModule: String?
        public let isMisplaced: Bool?
        public let opaque: Bool?
        public let rect: Rect
        public let subviews: [AnyView]?
        public let translatesAutoresizingMaskIntoConstraints: Bool?
        public let userInteractionEnabled: Bool?

        static func decode(_ xml: XMLIndexer) throws -> TableViewCell.TableViewContentView {
            return TableViewContentView.init(
                id:                                        try xml.attributeValue(of: "id"),
                autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
                contentMode:                               xml.attributeValue(of: "contentMode"),
                customClass:                               xml.attributeValue(of: "customClass"),
                customModule:                              xml.attributeValue(of: "customModule"),
                isMisplaced:                               xml.attributeValue(of: "misplaced"),
                opaque:                                    xml.attributeValue(of: "opaque"),
                rect:                                      try decodeValue(xml.byKey("rect")),
                subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
                translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> TableViewCell {
        return TableViewCell.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentView:                               try decodeValue(xml.byKey("tableViewCellContentView")),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            _subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - CollectionView

public struct CollectionView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UICollectionView"

    public let alwaysBounceHorizontal: Bool?
    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> CollectionView {
        return CollectionView.init(
            id:                                        try xml.attributeValue(of: "id"),
            alwaysBounceHorizontal:                    xml.attributeValue(of: "alwaysBounceHorizontal"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - CollectionViewCell

public struct CollectionViewCell: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UICollectionViewCell"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentView: View
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    private let _subviews: [AnyView]?
    public var subviews: [AnyView]? {
        return (_subviews ?? []) + [AnyView(contentView)]
    }
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> CollectionViewCell {
        return CollectionViewCell.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentView:                               try decodeValue(xml.byKey("view")),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            _subviews:                                 try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - Button

public struct Button: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIButton"

    public let autoresizingMask: AutoresizingMask?
    public let buttonType: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let lineBreakMode: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let textColor: TextColor
    public let title: Title
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct Title: XMLDecodable {
        public let disabled: String?
        public let highlighted: String?
        public let normal: String?
        public let selected: String?

        static func decode(_ xml: XMLIndexer) throws -> Button.Title {
            let allState = try xml.byKey("state").all

            func title(for key: String) -> String? {
                guard let stateElement = try? allState.first(where: { try $0.attributeValue(of: "key") == key }) else { return nil }
                return stateElement.flatMap { try? $0.attributeValue(of: "title") }
            }

            return Title.init(
                disabled: title(for: "disabled"),
                highlighted: title(for: "highlighted"),
                normal: title(for: "normal"),
                selected: title(for: "selected")
            )
        }
    }

    public struct TextColor: XMLDecodable {
        public let normal: Color?
        public let disabled: Color?
        public let selected: Color?
        public let highlighted: Color?

        static func decode(_ xml: XMLIndexer) throws -> Button.TextColor {
            let allState = try xml.byKey("state").all

            func color(for key: String) -> Color? {
                guard let colorElement = try? allState.first(where: { try $0.attributeValue(of: "key") == key })?.byKey("color") else { return nil }
                return colorElement.flatMap { try? Color.decode($0) }
            }
            return TextColor.init(
                normal: color(for: "normal"),
                disabled: color(for: "disabled"),
                selected: color(for: "selected"),
                highlighted: color(for: "highlighted")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Button {
        return Button.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            buttonType:                                xml.attributeValue(of: "buttonType"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            lineBreakMode:                             xml.attributeValue(of: "lineBreakMode"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            textColor:                                 try decodeValue(xml),
            title:                                     try decodeValue(xml),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - SegmentedControl

public struct SegmentedControl: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UISegmentedControl"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let segmentControlStyle: String?
    public let segments: [Segment]
    public let selectedSegmentIndex: Int?
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    public struct Segment: XMLDecodable {
        public let title: String

        static func decode(_ xml: XMLIndexer) throws -> SegmentedControl.Segment {
            return try Segment.init(title: xml.attributeValue(of: "title"))
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> SegmentedControl {
        return SegmentedControl.init(
            id:                                         try xml.attributeValue(of: "id"),
            autoresizingMask:                           xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                              xml.attributeValue(of: "clipsSubviews"),
            constraints:                                try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentHorizontalAlignment:                 xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                                xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                   xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                                xml.attributeValue(of: "customClass"),
            customModule:                               xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                     xml.attributeValue(of: "opaque"),
            rect:                                       try decodeValue(xml.byKey("rect")),
            segmentControlStyle:                        xml.attributeValue(of: "segmentControlStyle"),
            segments:                                   try xml.byKey("segments").byKey("segment").all.map(decodeValue),
            selectedSegmentIndex:                       xml.attributeValue(of: "selectedSegmentIndex"),
            subviews:                                   try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints:  xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                     xml.attributeValue(of: "userInteractionEnabled")
        )
    }

}

// MARK: - TextField

public struct TextField: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITextField"

    public let autoresizingMask: AutoresizingMask?
    public let borderStyle: String?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let fixedFrame: Bool?
    public let font: FontDescription?
    public let minimumFontSize: Float?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let textAlignment: String?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> TextField {
        return TextField.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            borderStyle:                               xml.attributeValue(of: "borderStyle"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            fixedFrame:                                xml.attributeValue(of: "fixedFrame"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            minimumFontSize:                           xml.attributeValue(of: "minimumFontSize"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            textAlignment:                             xml.attributeValue(of: "textAlignment"),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }

}

// MARK: - TextView

public struct TextView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UITextView"

    public let autoresizingMask: AutoresizingMask?
    public let bounces: Bool?
    public let bouncesZoom: Bool?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let font: FontDescription?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let scrollEnabled: Bool?
    public let showsHorizontalScrollIndicator: Bool?
    public let showsVerticalScrollIndicator: Bool?
    public let subviews: [AnyView]?
    public let text: String
    public let textAlignment: String?
    public let textColor: Color?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> TextView {
        return TextView.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            bounces:                                   xml.attributeValue(of: "bounces"),
            bouncesZoom:                               xml.attributeValue(of: "bouncesZoom"),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.map(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            scrollEnabled:                             xml.attributeValue(of: "scrollEnabled"),
            showsHorizontalScrollIndicator:            xml.attributeValue(of: "showsHorizontalScrollIndicator"),
            showsVerticalScrollIndicator:              xml.attributeValue(of: "showsVerticalScrollIndicator"),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            text:                                      try xml.attributeValue(of: "text"),
            textAlignment:                             xml.attributeValue(of: "textAlignment"),
            textColor:                                 xml.byKey("color").flatMap(decodeValue),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - Toolbar

public struct Toolbar: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIToolbar"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let items: [BarButtonItem]?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?


    public struct BarButtonItem: XMLDecodable {
        public let id: String
        public let style: String?
        public let systemItem: String?
        public let title: String?

        static func decode(_ xml: XMLIndexer) throws -> Toolbar.BarButtonItem {
            return BarButtonItem.init(
                id:         try xml.attributeValue(of: "id"),
                style:      xml.attributeValue(of: "style"),
                systemItem: xml.attributeValue(of: "systemItem"),
                title:      xml.attributeValue(of: "title")
            )
        }
    }

    static func decode(_ xml: XMLIndexer) throws -> Toolbar {
        return Toolbar.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            items:                                     try xml.byKey("items")?.byKey("barButtonItem")?.all.flatMap(BarButtonItem.decode),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - Switch

public struct Switch: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UISwitch"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentHorizontalAlignment: String?
    public let contentMode: String?
    public let contentVerticalAlignment: String?
    public let customClass: String?
    public let customModule: String?
    public let horizontalHuggingPriority: Int?
    public let isMisplaced: Bool?
    public let on: Bool
    public let onTintColor: Color?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?
    public let verticalHuggingPriority: Int?

    static func decode(_ xml: XMLIndexer) throws -> Switch {
        return Switch.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentHorizontalAlignment:                xml.attributeValue(of: "contentHorizontalAlignment"),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            contentVerticalAlignment:                  xml.attributeValue(of: "contentVerticalAlignment"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            horizontalHuggingPriority:                 xml.attributeValue(of: "horizontalHuggingPriority"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            on:                                        try xml.attributeValue(of: "on"),
            onTintColor:                               xml.byKey("color").flatMap(decodeValue),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
            verticalHuggingPriority:                   xml.attributeValue(of: "verticalHuggingPriority")
        )
    }
}

// MARK: - PickerView

public struct PickerView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIPickerView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> PickerView {
        return PickerView.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.map(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - ScrollView

public struct ScrollView: XMLDecodable, ViewProtocol {
    public let id: String
    public let elementClass: String = "UIScrollView"

    public let autoresizingMask: AutoresizingMask?
    public let clipsSubviews: Bool?
    public let constraints: [Constraint]?
    public let contentMode: String?
    public let customClass: String?
    public let customModule: String?
    public let isMisplaced: Bool?
    public let opaque: Bool?
    public let rect: Rect
    public let subviews: [AnyView]?
    public let translatesAutoresizingMaskIntoConstraints: Bool?
    public let userInteractionEnabled: Bool?

    static func decode(_ xml: XMLIndexer) throws -> ScrollView {
        return ScrollView.init(
            id:                                        try xml.attributeValue(of: "id"),
            autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
            clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
            constraints:                               try xml.byKey("constraints")?.byKey("constraint")?.all.flatMap(Constraint.decode),
            contentMode:                               xml.attributeValue(of: "contentMode"),
            customClass:                               xml.attributeValue(of: "customClass"),
            customModule:                              xml.attributeValue(of: "customModule"),
            isMisplaced:                               xml.attributeValue(of: "misplaced"),
            opaque:                                    xml.attributeValue(of: "opaque"),
            rect:                                      try decodeValue(xml.byKey("rect")),
            subviews:                                  try xml.byKey("subviews")?.children.flatMap(AnyView.decode),
            translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
            userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
        )
    }
}

// MARK: - Color

public enum Color: XMLDecodable {
    public typealias CalibratedWhite = (key: String, white: Float, alpha: Float)
    public typealias SRGB = (key: String, red: Float, blue: Float, green: Float, alpha: Float)
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
        let key: String = try xml.attributeValue(of: "key")
        let colorSpace: String = try xml.attributeValue(of: "colorSpace")
        switch colorSpace {
        case "calibratedWhite":
            return try .calibratedWhite((key:   key,
                                         white: xml.attributeValue(of: "white"),
                                         alpha: xml.attributeValue(of: "alpha")))
        case "custom":
            let customColorSpace: String = try xml.attributeValue(of: "customColorSpace")
            switch customColorSpace {
            case "sRGB":
                return try .sRGB((key:   key,
                                  red:   xml.attributeValue(of: "red"),
                                  blue:  xml.attributeValue(of: "blue"),
                                  green: xml.attributeValue(of: "green"),
                                  alpha: xml.attributeValue(of: "alpha")
                ))
            default:
                throw IBError.unsupportedColorSpace(customColorSpace)
            }
        default:
            throw IBError.unsupportedColorSpace(colorSpace)
        }
    }
}

// MARK: - AutoresizingMask

public struct AutoresizingMask: XMLDecodable {
    public let widthSizable: Bool
    public let heightSizable: Bool

    static func decode(_ xml: XMLIndexer) throws -> AutoresizingMask {
        return try AutoresizingMask.init(
            widthSizable:  xml.attributeValue(of: "widthSizable"),
            heightSizable: xml.attributeValue(of: "heightSizable"))
    }
}

// MARK: - Constraint

public struct Constraint: XMLDecodable {
    public let id: String
    public let constant: Int?
    public let multiplier: String?
    public let firstItem: String?
    public let firstAttribute: LayoutAttribute?
    public let secondItem: String?
    public let secondAttribute: LayoutAttribute?

    public enum LayoutAttribute: XMLAttributeDecodable, Equatable {
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
        return Constraint.init(
            id:              try xml.attributeValue(of: "id"),
            constant:        xml.attributeValue(of: "constant"),
            multiplier:      xml.attributeValue(of: "multiplier"),
            firstItem:       xml.attributeValue(of: "firstItem"),
            firstAttribute:  xml.attributeValue(of: "firstAttribute"),
            secondItem:      xml.attributeValue(of: "secondItem"),
            secondAttribute: xml.attributeValue(of: "secondAttribute")
        )
    }
}

// MARK: - FontDescription

public struct FontDescription: XMLDecodable {
    public let type: String
    public let pointSize: Float
    public let weight: String?

    static func decode(_ xml: XMLIndexer) throws -> FontDescription {
        return FontDescription.init(
            type:      try xml.attributeValue(of: "type"),
            pointSize: try xml.attributeValue(of: "pointSize"),
            weight:    xml.attributeValue(of: "weight")
        )
    }
}

// MARK: - Rect

public struct Rect: XMLDecodable {
    public let x: Float
    public let y: Float
    public let width: Float
    public let height: Float

    static func decode(_ xml: XMLIndexer) throws -> Rect {
        return Rect.init(
            x:      try xml.attributeValue(of: "x"),
            y:      try xml.attributeValue(of: "y"),
            width:  try xml.attributeValue(of: "width"),
            height: try xml.attributeValue(of: "height")
        )
    }
}
