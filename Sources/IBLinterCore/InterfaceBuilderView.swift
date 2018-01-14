//
//  InterfaceBuilderView.swift
//  IBLinterCore
//
//  Created by SaitoYuta on 2017/12/11.
//

public protocol ViewProtocol {
    var elementClass: String { get }
    var id: String { get }

    var autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask? { get }
    var clipsSubviews: Bool? { get }
    var connections: [InterfaceBuilderNode.View.Connection]? { get }
    var constraints: [InterfaceBuilderNode.View.Constraint]? { get }
    var contentMode: String? { get }
    var customClass: String? { get }
    var customModule: String? { get }
    var isMisplaced: Bool? { get }
    var opaque: Bool? { get }
    var rect: InterfaceBuilderNode.View.Rect { get }
    var subviews: [InterfaceBuilderNode.View]? { get }
    var translatesAutoresizingMaskIntoConstraints: Bool? { get }
    var userInteractionEnabled: Bool? { get }

}

extension InterfaceBuilderNode {
    public enum View: XMLDecodable, ViewProtocol {
        case barButtonItem(BarButtonItem)
        case button(Button)
        case collectionView(CollectionView)
        case collectionViewCell(CollectionViewCell)
        case imageView(ImageView)
        case label(Label)
        case pickerView(PickerView)
        case scrollView(ScrollView)
        case segmentedControl(SegmentedControl)
        case stackView(StackView)
        case `switch`(Switch)
        case tableView(TableView)
        case tableViewCell(TableViewCell)
        case tableViewCellContentView(TableViewCell.TableViewContentView)
        case textField(TextField)
        case textView(TextView)
        case toolbar(Toolbar)
        case view(View)

        public var id: String { return _view.id }
        public var elementClass: String { return _view.elementClass }

        public var autoresizingMask: AutoresizingMask? { return _view.autoresizingMask }
        public var clipsSubviews: Bool? { return _view.clipsSubviews }
        public var connections: [InterfaceBuilderNode.View.Connection]? { return _view.connections }
        public var constraints: [InterfaceBuilderNode.View.Constraint]? { return _view.constraints }
        public var contentMode: String? { return _view.contentMode }
        public var customClass: String? { return _view.customClass }
        public var customModule: String? { return _view.customModule }
        public var isMisplaced: Bool? { return _view.isMisplaced }
        public var opaque: Bool? { return _view.opaque }
        public var rect: InterfaceBuilderNode.View.Rect { return _view.rect }
        public var subviews: [InterfaceBuilderNode.View]? { return _view.subviews }
        public var translatesAutoresizingMaskIntoConstraints: Bool? { return _view.translatesAutoresizingMaskIntoConstraints }
        public var userInteractionEnabled: Bool? { return _view.userInteractionEnabled }

        private var _view: ViewProtocol {
            switch self {
            case .barButtonItem(let barButtonItem):           return barButtonItem
            case .button(let button):                         return button
            case .collectionView(let collectionView):         return collectionView
            case .collectionViewCell(let collectionViewCell): return collectionViewCell
            case .imageView(let imageView):                   return imageView
            case .label(let label):                           return label
            case .pickerView(let pickerView):                 return pickerView
            case .scrollView(let scrollView):                 return scrollView
            case .segmentedControl(let segmentedControl):     return segmentedControl
            case .stackView(let stackView):                   return stackView
            case .switch(let switchView):                     return switchView
            case .tableView(let tableView):                   return tableView
            case .tableViewCell(let tableViewCell):           return tableViewCell
            case .tableViewCellContentView(let contentView):  return contentView
            case .textField(let textField):                   return textField
            case .textView(let textView):                     return textView
            case .toolbar(let toolbar):                       return toolbar
            case .view(let view):                             return view
            }
        }

        static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View {
            guard let elementName = xml.elementNode?.name else { throw Error.elementNotFound }
            switch elementName {
            case "button":                   return try .button(decodeValue(xml))
            case "collectionView":           return try .collectionView(decodeValue(xml))
            case "collectionViewCell":       return try .collectionViewCell(decodeValue(xml))
            case "imageView":                return try .imageView(decodeValue(xml))
            case "label":                    return try .label(decodeValue(xml))
            case "pickerView":               return try .pickerView(decodeValue(xml))
            case "scrollView":               return try .scrollView(decodeValue(xml))
            case "segmentedControl":         return try .segmentedControl(decodeValue(xml))
            case "stackView":                return try .stackView(decodeValue(xml))
            case "switch":                   return try .switch(decodeValue(xml))
            case "tableView":                return try .tableView(decodeValue(xml))
            case "tableViewCell":            return try .tableViewCell(decodeValue(xml))
            case "tableViewCellContentView": return try .tableViewCellContentView(decodeValue(xml))
            case "textField":                return try .textField(decodeValue(xml))
            case "textView":                 return try .textView(decodeValue(xml))
            case "toolbar":                  return try .toolbar(decodeValue(xml))
            case "view":                     return try .view(decodeValue(xml))
            default:                         throw Error.unsupportedViewClass(elementName)
            }
        }

        public struct View: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIView"

            public let autoresizingMask: AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?
            public let viewLayoutGuide: LayoutGuide?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.View {
                return View.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
                    viewLayoutGuide:                           xml.byKey("viewLayoutGuide").flatMap(decodeValue)
                )
            }
        }

        public struct StackView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIStackView"

            public let alignment: String?
            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let axis: String?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.StackView {
                return StackView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    alignment:                                 xml.attributeValue(of: "alignment"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    axis:                                      xml.attributeValue(of: "axis"),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct ImageView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIImageView"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let image: String
            public let insetsLayoutMarginsFromSafeArea: Bool?
            public let isMisplaced: Bool?
            public let multipleTouchEnabled: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.ImageView {
                return ImageView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    image:                                     try xml.attributeValue(of: "image"),
                    insetsLayoutMarginsFromSafeArea:           xml.attributeValue(of: "insetsLayoutMarginsFromSafeArea"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    multipleTouchEnabled:                      xml.attributeValue(of: "multipleTouchEnabled"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct Label: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UILabel"

            public let adjustsFontSizeToFit: Bool?
            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let baselineAdjustment: String?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let font: FontDescription?
            public let horizontalHuggingPriority: Int?
            public let lineBreakMode: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let text: String
            public let textAlignment: String?
            public let textColor: Color?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?
            public let verticalHuggingPriority: Int?


            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Label {
                return Label.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    adjustsFontSizeToFit:                      xml.attributeValue(of: "adjustsFontSizeToFit"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    baselineAdjustment:                        xml.attributeValue(of: "baselineAdjustment"),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    font:                                      xml.byKey("fontDescription").flatMap(decodeValue),
                    horizontalHuggingPriority:                 xml.attributeValue(of: "horizontalHuggingPriority"),
                    lineBreakMode:                             xml.attributeValue(of: "lineBreakMode"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    text:                                      try xml.attributeValue(of: "text"),
                    textAlignment:                             xml.attributeValue(of: "textAlignment"),
                    textColor:                                 xml.byKey("color").flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
                    verticalHuggingPriority:                   xml.attributeValue(of: "verticalHuggingPriority")
                )
            }

        }

        public struct TableView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UITableView"

            public let alwaysBounceVertical: Bool?
            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let dataMode: DataMode?
            public let estimatedRowHeight: Float?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let rowHeight: Float?
            public let sections: [TableViewSection]?
            public let sectionFooterHeight: Float?
            public let sectionHeaderHeight: Float?
            public let separatorStyle: String?
            public let style: String?
            private let _subviews: [InterfaceBuilderNode.View]?
            public var subviews: [InterfaceBuilderNode.View]? {
                let cells: [InterfaceBuilderNode.View.TableViewCell]? = sections?.flatMap { $0.cells }.flatMap { $0 }
                return (_subviews ?? []) + (cells?.map { .tableViewCell($0) } ?? [])
            }
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            public struct TableViewSection: XMLDecodable {

                public let id: String
                public let headerTitle: String?
                public let cells: [InterfaceBuilderNode.View.TableViewCell]?

                static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.TableView.TableViewSection {
                    return TableViewSection.init(
                        id:          try xml.attributeValue(of: "id"),
                        headerTitle: xml.attributeValue(of: "headerTitle"),
                        cells:       xml.byKey("cells")?.byKey("tableViewCell")?.allElements.flatMap(decodeValue)
                    )
                }
            }

            public enum DataMode: XMLAttributeDecodable {
                case `static`, prototypes

                public static func decode(_ attribute: XMLAttributeProtocol) throws -> InterfaceBuilderNode.View.TableView.DataMode {
                    switch attribute.text {
                    case "static":     return .static
                    case "prototypes": return .prototypes
                    default:
                        throw Error.unsupportedTableViewDataMode(attribute.text)
                    }
                }
            }

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.TableView {
                return TableView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    alwaysBounceVertical:                      xml.attributeValue(of: "alwaysBounceVertical"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    dataMode:                                  xml.attributeValue(of: "dataMode"),
                    estimatedRowHeight:                        xml.attributeValue(of: "estimatedRowHeight"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    rowHeight:                                 xml.attributeValue(of: "rowHeight"),
                    sections:                                  xml.byKey("sections")?.byKey("tableViewSection")?.allElements.flatMap(decodeValue),
                    sectionFooterHeight:                       xml.attributeValue(of: "sectionFooterHeight"),
                    sectionHeaderHeight:                       xml.attributeValue(of: "sectionHeaderHeight"),
                    separatorStyle:                            xml.attributeValue(of: "separatorStyle"),
                    style:                                     xml.attributeValue(of: "style"),
                    _subviews:                                 xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct TableViewCell: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UITableView"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentView: TableViewContentView
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            private let _subviews: [InterfaceBuilderNode.View]?
            public var subviews: [InterfaceBuilderNode.View]? {
                return (_subviews ?? []) + [.tableViewCellContentView(contentView)]
            }
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            public struct TableViewContentView: XMLDecodable, ViewProtocol {
                public let id: String
                public let elementClass: String = "UITableViewContentView"

                public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
                public let clipsSubviews: Bool?
                public let connections: [InterfaceBuilderNode.View.Connection]?
                public let constraints: [InterfaceBuilderNode.View.Constraint]?
                public let contentMode: String?
                public let customClass: String?
                public let customModule: String?
                public let isMisplaced: Bool?
                public let opaque: Bool?
                public let rect: InterfaceBuilderNode.View.Rect
                public let subviews: [InterfaceBuilderNode.View]?
                public let translatesAutoresizingMaskIntoConstraints: Bool?
                public let userInteractionEnabled: Bool?

                static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.TableViewCell.TableViewContentView {
                    let subviews: [InterfaceBuilderNode.View]? = xml.byKey("subviews")?.childrenNode.flatMap(decodeValue)
                    print(subviews)
                    return TableViewContentView.init(
                        id:                                        try xml.attributeValue(of: "id"),
                        autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                        clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                        connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                        constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                        contentMode:                               xml.attributeValue(of: "contentMode"),
                        customClass:                               xml.attributeValue(of: "customClass"),
                        customModule:                              xml.attributeValue(of: "customModule"),
                        isMisplaced:                               xml.attributeValue(of: "misplaced"),
                        opaque:                                    xml.attributeValue(of: "opaque"),
                        rect:                                      try decodeValue(xml.byKey("rect")),
                        subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                        translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                        userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                    )
                }
            }

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.TableViewCell {
                return TableViewCell.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentView:                               try decodeValue(xml.byKey("tableViewCellContentView")),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    _subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }
        public struct CollectionView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UICollectionView"

            public let alwaysBounceHorizontal: Bool?
            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.CollectionView {
                return CollectionView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    alwaysBounceHorizontal:                    xml.attributeValue(of: "alwaysBounceHorizontal"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct CollectionViewCell: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UICollectionViewCell"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentView: View
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            private let _subviews: [InterfaceBuilderNode.View]?
            public var subviews: [InterfaceBuilderNode.View]? {
                return (_subviews ?? []) + [.view(contentView)]
            }
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.CollectionViewCell {
                return CollectionViewCell.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentView:                               try decodeValue(xml.byKey("view")),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    _subviews:                                 xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct Button: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIButton"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let buttonType: String?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentHorizontalAlignment: String?
            public let contentMode: String?
            public let contentVerticalAlignment: String?
            public let customClass: String?
            public let customModule: String?
            public let font: FontDescription?
            public let lineBreakMode: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let textColor: TextColor?
            public let title: Title?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            public struct Title: XMLDecodable {
                public let disabled: String?
                public let highlighted: String?
                public let normal: String?
                public let selected: String?

                static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Button.Title {
                    let allState = try xml.byKey("state").allElements

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

                static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Button.TextColor {
                    let allState = try xml.byKey("state").allElements

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

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Button {
                return Button.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    buttonType:                                xml.attributeValue(of: "buttonType"),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
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
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    textColor:                                 try decodeValue(xml),
                    title:                                     try decodeValue(xml),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct SegmentedControl: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UISegmentedControl"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentHorizontalAlignment: String?
            public let contentMode: String?
            public let contentVerticalAlignment: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let segmentControlStyle: String?
            public let segments: [Segment]
            public let selectedSegmentIndex: Int?
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            public struct Segment: XMLDecodable {
                public let title: String

                static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.SegmentedControl.Segment {
                    return try Segment.init(title: xml.attributeValue(of: "title"))
                }
            }

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.SegmentedControl {
                return SegmentedControl.init(
                    id:                                         try xml.attributeValue(of: "id"),
                    autoresizingMask:                           xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                              xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                                xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentHorizontalAlignment:                 xml.attributeValue(of: "contentHorizontalAlignment"),
                    contentMode:                                xml.attributeValue(of: "contentMode"),
                    contentVerticalAlignment:                   xml.attributeValue(of: "contentVerticalAlignment"),
                    customClass:                                xml.attributeValue(of: "customClass"),
                    customModule:                               xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                     xml.attributeValue(of: "opaque"),
                    rect:                                       try decodeValue(xml.byKey("rect")),
                    segmentControlStyle:                        xml.attributeValue(of: "segmentControlStyle"),
                    segments:                                   try xml.byKey("segments").byKey("segment").allElements.map(decodeValue),
                    selectedSegmentIndex:                       xml.attributeValue(of: "selectedSegmentIndex"),
                    subviews:                                   xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints:  xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                     xml.attributeValue(of: "userInteractionEnabled")
                )
            }

        }

        public struct TextField: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UITextField"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let borderStyle: String?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
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
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let textAlignment: String?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.TextField {
                return TextField.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    borderStyle:                               xml.attributeValue(of: "borderStyle"),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
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
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    textAlignment:                             xml.attributeValue(of: "textAlignment"),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }

        }

        public struct TextView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UITextView"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let bounces: Bool?
            public let bouncesZoom: Bool?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let font: FontDescription?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let scrollEnabled: Bool?
            public let showsHorizontalScrollIndicator: Bool?
            public let showsVerticalScrollIndicator: Bool?
            public let subviews: [InterfaceBuilderNode.View]?
            public let text: String
            public let textAlignment: String?
            public let textColor: Color?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.TextView {
                return TextView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    bounces:                                   xml.attributeValue(of: "bounces"),
                    bouncesZoom:                               xml.attributeValue(of: "bouncesZoom"),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
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
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    text:                                      try xml.attributeValue(of: "text"),
                    textAlignment:                             xml.attributeValue(of: "textAlignment"),
                    textColor:                                 xml.byKey("color").flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct Toolbar: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIToolbar"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let items: [BarButtonItem]?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?


            public struct BarButtonItem: XMLDecodable {
                public let id: String
                public let style: String?
                public let systemItem: String?
                public let title: String?

                static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Toolbar.BarButtonItem {
                    return BarButtonItem.init(
                        id:         try xml.attributeValue(of: "id"),
                        style:      xml.attributeValue(of: "style"),
                        systemItem: xml.attributeValue(of: "systemItem"),
                        title:      xml.attributeValue(of: "title")
                    )
                }
            }

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Toolbar {
                return Toolbar.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    items:                                     xml.byKey("items")?.byKey("barButtonItem")?.allElements.flatMap(decodeValue),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct Switch: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UISwitch"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
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
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?
            public let verticalHuggingPriority: Int?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Switch {
                return Switch.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
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
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled"),
                    verticalHuggingPriority:                   xml.attributeValue(of: "verticalHuggingPriority")
                )
            }
        }

        public struct PickerView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIPickerView"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.PickerView {
                return PickerView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct ScrollView: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIScrollView"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.ScrollView {
                return ScrollView.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

        public struct BarButtonItem: XMLDecodable, ViewProtocol {
            public let id: String
            public let elementClass: String = "UIBarButtonItem"

            public let autoresizingMask: InterfaceBuilderNode.View.AutoresizingMask?
            public let clipsSubviews: Bool?
            public let connections: [InterfaceBuilderNode.View.Connection]?
            public let constraints: [InterfaceBuilderNode.View.Constraint]?
            public let contentMode: String?
            public let customClass: String?
            public let customModule: String?
            public let isMisplaced: Bool?
            public let opaque: Bool?
            public let rect: InterfaceBuilderNode.View.Rect
            public let subviews: [InterfaceBuilderNode.View]?
            public let translatesAutoresizingMaskIntoConstraints: Bool?
            public let userInteractionEnabled: Bool?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.BarButtonItem {
                return BarButtonItem.init(
                    id:                                        try xml.attributeValue(of: "id"),
                    autoresizingMask:                          xml.byKey("autoresizingMask").flatMap(decodeValue),
                    clipsSubviews:                             xml.attributeValue(of: "clipsSubviews"),
                    connections:                               xml.byKey("connections")?.childrenNode.flatMap(decodeValue),
                    constraints:                               xml.byKey("constraints")?.byKey("constraint")?.allElements.flatMap(decodeValue),
                    contentMode:                               xml.attributeValue(of: "contentMode"),
                    customClass:                               xml.attributeValue(of: "customClass"),
                    customModule:                              xml.attributeValue(of: "customModule"),
                    isMisplaced:                               xml.attributeValue(of: "misplaced"),
                    opaque:                                    xml.attributeValue(of: "opaque"),
                    rect:                                      try decodeValue(xml.byKey("rect")),
                    subviews:                                  xml.byKey("subviews")?.childrenNode.flatMap(decodeValue),
                    translatesAutoresizingMaskIntoConstraints: xml.attributeValue(of: "translatesAutoresizingMaskIntoConstraints"),
                    userInteractionEnabled:                    xml.attributeValue(of: "userInteractionEnabled")
                )
            }
        }

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

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Color {
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
                        throw Error.unsupportedColorSpace(customColorSpace)
                    }
                default:
                    throw Error.unsupportedColorSpace(colorSpace)
                }
            }
        }

        public struct FontDescription: XMLDecodable {
            public let type: String
            public let pointSize: Float
            public let weight: String?

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.FontDescription {
                return FontDescription.init(
                    type:      try xml.attributeValue(of: "type"),
                    pointSize: try xml.attributeValue(of: "pointSize"),
                    weight:    xml.attributeValue(of: "weight")
                )
            }
        }

        public struct Rect: XMLDecodable {
            public let x: Float
            public let y: Float
            public let width: Float
            public let height: Float

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Rect {
                return Rect.init(
                    x:      try xml.attributeValue(of: "x"),
                    y:      try xml.attributeValue(of: "y"),
                    width:  try xml.attributeValue(of: "width"),
                    height: try xml.attributeValue(of: "height")
                )
            }
        }

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

                public static func decode(_ attribute: XMLAttributeProtocol) throws -> InterfaceBuilderNode.View.Constraint.LayoutAttribute {
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

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Constraint {
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

        public enum Connection: XMLDecodable, Equatable {

            case outlet(property: String, destination: String, id: String)
            case outletCollection(property: String, destination: String, collectionClass: String, id: String)
            case action(selector: String, destination: String, eventType: String, id: String)

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.Connection {
                guard let elementName = xml.elementNode?.name else { throw Error.elementNotFound }
                switch elementName {
                case "outlet":
                    return try .outlet(
                        property: xml.attributeValue(of: "property"),
                        destination: xml.attributeValue(of: "destination"),
                        id: xml.attributeValue(of: "id")
                    )
                case "outletCollection":
                    return try .outletCollection(
                        property: xml.attributeValue(of: "property"),
                        destination: xml.attributeValue(of: "destination"),
                        collectionClass: xml.attributeValue(of: "collectionClass"),
                        id: xml.attributeValue(of: "id")
                    )
                case "action":
                    let selector: String = try xml.attributeValue(of: "selector")
                    let a: Connection = try .action(
                        selector: selector,
                        destination: xml.attributeValue(of: "destination"),
                        eventType: xml.attributeValue(of: "eventType"),
                        id: xml.attributeValue(of: "id"))
                    print(a)
                    return a
                default:
                    throw Error.unsupportedConnectionType(elementName)
                }
            }

            public static func ==(lhs: InterfaceBuilderNode.View.Connection, rhs: InterfaceBuilderNode.View.Connection) -> Bool {
                switch (lhs, rhs) {
                case (.outlet(let property1, let destination1, let id1),
                      .outlet(let property2, let destination2, let id2)):
                    return property1 == property2 && destination1 == destination2 && id1 == id2
                case (.outletCollection(let property1, let destination1, let collectionClass1, let id1),
                      .outletCollection(let property2, let destination2, let collectionClass2, let id2)):
                    return property1 == property2 && destination1 == destination2 && collectionClass1 == collectionClass2 && id1 == id2
                case (.action(let selector1, let destination1, let eventType1, let id1),
                      .action(let selector2, let destination2, let eventType2, let id2)):
                    return selector1 == selector2 && destination1 == destination2 && eventType1 == eventType2 && id1 == id2
                default: return false
                }
            }
        }

        public struct AutoresizingMask: XMLDecodable {
            public let widthSizable: Bool
            public let heightSizable: Bool

            static func decode(_ xml: XMLIndexerProtocol) throws -> InterfaceBuilderNode.View.AutoresizingMask {
                return try AutoresizingMask.init(
                    widthSizable:  xml.attributeValue(of: "widthSizable"),
                    heightSizable: xml.attributeValue(of: "heightSizable"))
            }
        }
    }
}
