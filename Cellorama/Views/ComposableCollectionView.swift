//
//  ComposableCollectionView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/17/22.
//

import Foundation
import UIKit

final class ComposableCollectionView: UICollectionView, CollectionViewable {
    
    var source: CollectionSourceable {
        didSet {
            collectionViewLayout = source.layout
            collectionViewLayout.invalidateLayout()
        }
    }
    
    init(source: CollectionSourceable) {
        self.source = source
        super.init(frame: .zero, collectionViewLayout: source.layout)
        
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
