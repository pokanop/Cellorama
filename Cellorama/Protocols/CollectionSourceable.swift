//
//  CollectionSourceable.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/17/22.
//

import Foundation
import UIKit

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
    
    mutating func randomize() {
        container.randomize()
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
    
    mutating func randomize() {
        var items: [AnyItem] = []
        self.items.forEach { item in
            if var item = item.asContainer {
                item.randomize()
                items.append(AnyItem(item))
            } else if var item = item.asElement {
                item.randomize()
                items.append(AnyItem(item))
            }
        }
        
        self.items = isRoot ? items : items.shuffled()
    }
    
}

private extension Element {
    
    mutating func randomize() {
        
    }
    
}
