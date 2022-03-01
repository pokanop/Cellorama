//
//  CollectionSourceable.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/17/22.
//

import Foundation
import UIKit

enum AnimationType: Int, RawRepresentable {
    
    case moveItems
    case insertItems
    case deleteItems
    case moveSections
    case insertSections
    case deleteSections
    case all
    
    var next: AnimationType {
        AnimationType(rawValue: rawValue + 1) ?? AnimationType(rawValue: 0)!
    }
    
}

protocol CollectionSourceable {
    
    var layout: UICollectionViewLayout { get }
    var container: Container { get set }
    var items: [AnyItem] { get set }
    var numberOfItems: Int { get }
    
}

extension CollectionSourceable {
    
    var items: [AnyItem] {
        get { container.items }
        set { container.items = newValue }
    }
    
    var numberOfItems: Int { items.count }
    
    mutating func updateSectionCount(_ count: Int) {
        container.updateItemCount(count)
    }
    
    mutating func updateItemCount(_ count: Int) {
        var items: [AnyItem] = []
        self.items.forEach { item in
            guard var item = item.asContainer else { return }
            item.updateItemCount(count)
            items.append(AnyItem(item))
        }
        self.items = items
    }
    
    mutating func updateSize(_ size: View.Size) {
        container.updateSize(size)
    }
    
    mutating func updateColumnCount(_ count: Int) {
        container.updateColumnCount(count)
    }
    
    mutating func randomize(_ animationType: AnimationType) {
        container.randomize(animationType)
    }
    
}

private extension Container {
    
    mutating func updateItemCount(_ count: Int) {
        var items: [AnyItem] = []
        for i in 0..<count {
            if self.items.count > i {
                if var item = self.items[i].asContainer {
                    item.updateItemCount(options.items)
                    items.append(AnyItem(item))
                } else {
                    items.append(self.items[i])
                }
            } else {
                if isRoot {
                    items.append(contentsOf: containers(count: count - i,
                                                        style: currentTabStyle.layout,
                                                        size: options.size))
                } else {
                    items.append(contentsOf: elements(count: count - i, size: options.size))
                }
            }
        }
        self.items = items
    }
    
    mutating func updateSize(_ size: View.Size) {
        var items: [AnyItem] = []
        self.items.forEach { item in
            if var item = item.asContainer {
                item.updateSize(size)
                items.append(AnyItem(item))
            } else if var item = item.asElement {
                item.size = size
                items.append(AnyItem(item))
            }
        }
        self.items = items
    }
    
    mutating func updateColumnCount(_ count: Int) {
        if isGrid {
            layoutStyle = .grid(count)
        }
        
        var items: [AnyItem] = []
        self.items.forEach { item in
            guard var item = item.asContainer else {
                items.append(item)
                return
            }
            item.updateColumnCount(count)
            items.append(AnyItem(item))
        }
        self.items = items
    }
    
    mutating func randomize(_ animationType: AnimationType) {
        var items: [AnyItem] = []
        self.items.forEach { item in
            if var item = item.asContainer {
                item.randomize(animationType)
                items.append(AnyItem(item))
            } else if var item = item.asElement {
                item.randomize(animationType)
                items.append(AnyItem(item))
            }
        }
        
        switch animationType {
        case .moveItems:
            self.items = isRoot ? items : items.shuffled()
        case .insertItems:
            if !isRoot {
                elements(count: Int.random(in: 1...5), size: options.size).forEach { element in
                    items.insert(element, at: Int.random(in: 0...items.count - 1))
                }
            }
            self.items = items
        case .deleteItems:
            if !isRoot {
                (1...items.count / 2).forEach { _ in items.remove(at: Int.random(in: 0...items.count - 1)) }
            }
            self.items = items
        case .moveSections:
            self.items = isRoot ? items.shuffled() : items
        case .insertSections:
            if isRoot {
                containers(count: Int.random(in: 1...5),
                           style: currentTabStyle.layout,
                           size: options.size).forEach { container in
                    items.insert(container, at: Int.random(in: 0...items.count - 1))
                }
            }
            self.items = items
        case .deleteSections:
            if isRoot {
                (1...items.count / 2).forEach { _ in items.remove(at: Int.random(in: 0...items.count - 1)) }
            }
            self.items = items
        case .all:
            break
        }
    }
    
}

private extension Element {
    
    mutating func randomize(_ animationType: AnimationType) {
        
    }
    
}
