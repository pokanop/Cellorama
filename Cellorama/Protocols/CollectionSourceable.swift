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
    var container: Container { get }
    var items: [AnyItem] { get }
    var numberOfItems: Int { get }
    
}

extension CollectionSourceable {
    
    var items: [AnyItem] { container.items }
    var numberOfItems: Int { items.count }
    
}
