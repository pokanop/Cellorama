//
//  CollectionViewable.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/17/22.
//

import Foundation
import UIKit

typealias CollectionView = CollectionViewable & UICollectionView

protocol CollectionViewable {
    
    var source: CollectionSourceable { get set }
    var container: Container { get }
    
}

extension CollectionViewable {
    
    var container: Container { source.container }
    
}
