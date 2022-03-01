//
//  Item.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

enum ItemKind: CaseIterable {
    
    case container
    case element
    
}

enum LayoutStyle: CaseIterable, CustomStringConvertible, Equatable {
    
    case zone
    case grid(Int)
    case carousel
    
    static var allCases: [LayoutStyle] { [.zone, .grid(Int.random(in: 1...5)), .carousel] }
    
    var description: String {
        switch self {
        case .zone: return "zone"
        case .grid: return "grid"
        case .carousel: return "carousel"
        }
    }
    
}

extension CaseIterable {
    
    static var random: Self { allCases.randomElement()! }
    
}

protocol Item: Hashable {
    
    var identifier: UUID { get }
    var kind: ItemKind { get }
    var asContainer: Container? { get }
    var asElement: Element? { get }
    
}

extension Item {
    
    var asContainer: Container? { self as? Container }
    var asElement: Element? { self as? Element }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
}

private protocol _AnyItemBox {
    
    var _base: Any { get }
    var _identifier: UUID { get }
    var _kind: ItemKind { get }
    var _asContainer: Container? { get }
    var _asElement: Element? { get }
    
    func _unbox<T: Item>() -> T?
    func _isEqual(to other: _AnyItemBox) -> Bool
    
}

private struct _ConcreteItemBox<T: Item>: _AnyItemBox {
    
    var _baseItem: T
    var _base: Any { _baseItem }
    var _identifier: UUID { _baseItem.identifier }
    var _kind: ItemKind { _baseItem.kind }
    var _asContainer: Container? { _baseItem as? Container }
    var _asElement: Element? { _baseItem as? Element }
    
    init(_ base: T) {
        self._baseItem = base
    }
    
    func _unbox<T: Item>() -> T? {
        (self as _AnyItemBox as? _ConcreteItemBox<T>)?._baseItem
    }
    
    func _isEqual(to other: _AnyItemBox) -> Bool {
        guard let rhs: T = other._unbox() else { return false }
        return _baseItem == rhs
    }
    
}

struct AnyItem: Item {
    
    private var _box: _AnyItemBox
    var identifier: UUID { _box._identifier }
    var kind: ItemKind { _box._kind }
    var asContainer: Container? { _box._asContainer }
    var asElement: Element? { _box._asElement }
    
    static func == (lhs: AnyItem, rhs: AnyItem) -> Bool {
        lhs._box._isEqual(to: rhs._box)
    }
    
    init<T: Item>(_ value: T) {
        self._box = _ConcreteItemBox(value)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(_box._identifier)
    }
    
}

struct Container: Item {
    
    var identifier: UUID = UUID()
    var kind: ItemKind = .container
    var layoutStyle: LayoutStyle = .zone
    var items: [AnyItem] = []
    var itemSpacing: CGFloat = 10.0
    var insets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    var isRoot: Bool = false
    var isZone: Bool { layoutStyle == .zone }
    var isGrid: Bool { if case .grid(_) = layoutStyle { return true } else { return false } }
    var isCarousel: Bool { layoutStyle == .carousel }
    
    var itemsPerRow: CGFloat {
        guard case .grid(let items) = layoutStyle else { return 1.0 }
        return CGFloat(items)
    }
    
    static func == (lhs: Container, rhs: Container) -> Bool {
        lhs.identifier == rhs.identifier
    }
    
    func maxWidth(for bounds: CGRect) -> CGFloat {
        max(bounds.width - insets.left - insets.right, 0)
    }
    
    func maxHeight(for height: CGFloat) -> CGFloat {
        height + insets.top + insets.bottom
    }
    
    func maxItemWidth(for bounds: CGRect, minimumInteritemSpacing: CGFloat) -> CGFloat {
        guard case .grid(let items) = layoutStyle else { return 0 }
        
        let width = maxWidth(for: bounds) - CGFloat(items - 1) * minimumInteritemSpacing - insets.left - insets.right
        
        return width / CGFloat(items)
    }
    
}

struct Element: Item {
    
    var identifier: UUID = UUID()
    var kind: ItemKind = .element
    var data: String = randomEmoji()
    var size: View.Size = .random
    var color: UIColor = randomColor()
    
}

func randomEmoji() -> String {
    ["👊", "🤲", "🙌", "👏", "🤝", "👍", "👎", "✊", "🤛", "🤞", "✌️", "🤟", "👌", "🤏", "☝️", "🖖", "🤙"].randomElement()!
}

func randomColor() -> UIColor {
    [.blue, .black, .red, .green, .yellow, .brown, .cyan, .darkGray, .gray, .lightGray, .magenta, .orange, .purple].randomElement()!
}

func randomElements(count: Int) -> [AnyItem] {
    (0..<count).map { _ in AnyItem(Element()) }
}

func randomContainers(count: Int, style: LayoutStyle?) -> [AnyItem] {
    (0..<count).map { _ in AnyItem(Container(layoutStyle: style ?? .random,
                                             items: randomElements(count: options.items))) }
}

func randomItems(count: Int, depth: Int = 0) -> [AnyItem] {
    var items: [AnyItem] = []
    for _ in 0..<count {
        if Bool.random() {
            items.append(AnyItem(Element()))
        } else {
            if depth > 2 {
                items.append(AnyItem(Container(items: randomElements(count: (5...20).randomElement()!))))
            } else {
                items.append(AnyItem(Container(layoutStyle: .random,
                                               items: randomItems(count: (1...3).randomElement()!,
                                                   depth: depth + 1))))
            }
        }
    }
    return items
}

func elements(count: Int, size: View.Size) -> [AnyItem] {
    (0..<count).map { _ in AnyItem(Element(size: size)) }
}

func containers(count: Int, style: LayoutStyle, size: View.Size) -> [AnyItem] {
    (0..<count).map { _ in AnyItem(Container(layoutStyle: style,
                                             items: elements(count: options.items, size: size))) }
}
