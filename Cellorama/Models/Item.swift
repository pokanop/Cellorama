//
//  Item.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

enum ItemKind {
    
    case container
    case element
    
}

enum LayoutStyle {
    case zone
    case grid
    case carousel
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
    
    func maxWidth(for bounds: CGRect) -> CGFloat {
        bounds.width - insets.left - insets.right
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
    [.blue, .black, .red, .green, .yellow, .brown, .cyan, .darkGray, .gray, .lightGray, .magenta, .orange, .purple, .white].randomElement()!
}

func randomElements(count: Int) -> [Item] {
    var items: [Item] = []
    for _ in 0..<count {
        items.append(Element())
    }
    return items
}

func randomItems(count: Int) -> [Item] {
    var items: [Item] = []
    for _ in 0..<count {
        if Bool.random() {
            items.append(Element())
        } else {
            items.append(Container(items: randomElements(count: 20)))
        }
    }
    return items
}
