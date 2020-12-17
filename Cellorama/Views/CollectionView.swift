//
//  CollectionView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class CollectionView: UICollectionView {
    
    let layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = 10.0
        layout.sectionInset = UIEdgeInsets(top: 8.0, left: 8.0, bottom: 8.0, right: 8.0)
        return layout
    }()
    
    let source: CollectionDataSource
    
    init(source: CollectionDataSource) {
        self.source = source
        super.init(frame: .zero, collectionViewLayout: layout)
        
        dataSource = source
        delegate = source
        backgroundColor = .white
        
        register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
