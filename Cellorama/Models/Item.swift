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

enum LayoutStyle: CaseIterable, Equatable {
    
    case zone
    case grid(Int)
    case carousel
    
    static var allCases: [LayoutStyle] { [.zone, .grid(2), .carousel] }
    
}

extension CaseIterable {
    
    static var random: Self { allCases.randomElement()! }
    
}

protocol Item {
    
    var kind: ItemKind { get }
    var asContainer: Container? { get }
    var asElement: Element? { get }
    
}

extension Item {
    
    var asContainer: Container? { self as? Container }
    var asElement: Element? { self as? Element }
    
}

struct Container: Item {
    
    var kind: ItemKind = .container
    var layoutStyle: LayoutStyle = .zone
    var items: [Item] = []
    var itemSpacing: CGFloat = 10.0
    var insets: UIEdgeInsets = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
    var isRoot: Bool = false
    var maxItemHeight: CGFloat = 0.0
    
    func maxWidth(for bounds: CGRect) -> CGFloat {
//        if case .grid(let items) = layoutStyle {
//            return bounds.width / CGFloat(items) - insets.left - insets.right
//        } else {
            return max(bounds.width - insets.left - insets.right, 0)
//        }
    }
    
    func maxHeight(for height: CGFloat) -> CGFloat {
        height + insets.top + insets.bottom
    }
    
}

struct Element: Item {
    
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

func randomElements(count: Int) -> [Item] {
    var items: [Item] = []
    for _ in 0..<count {
        items.append(Element())
    }
    return items
}

func randomItems(count: Int, depth: Int = 0) -> [Item] {
    var items: [Item] = []
    for _ in 0..<count {
        if Bool.random() {
            items.append(Element())
        } else {
            if depth > 2 {
                items.append(Container(items: randomElements(count: (5...20).randomElement()!)))
            } else {
                items.append(Container(layoutStyle: .random,
                                       items: randomItems(count: (1...3).randomElement()!,
                                                   depth: depth + 1)))
            }
        }
    }
    return items
}

func elements(count: Int, size: View.Size) -> [Item] {
    (0..<count).map { _ in Element(size: size) }
}

func containers(count: Int, style: LayoutStyle, size: View.Size) -> [Item] {
    (0..<count).map { _ in Container(layoutStyle: style,
                                     items: elements(count: count, size: size)) }
}
