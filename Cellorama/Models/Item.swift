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
    var items: [Item] = []
    
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
