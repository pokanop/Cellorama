//
//  LegacyCollectionView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

final class LegacyCollectionView: UICollectionView, UICollectionViewDelegateFlowLayout, CollectionViewable {
    
    var source: CollectionSourceable {
        didSet {
            guard let source = legacySource else { return }
            
            DispatchQueue.main.async {
                self.collectionViewLayout = source.layout
                self.dataSource = source
                self.delegate = source
                self.reloadData()
            }
        }
    }
    
    private var legacySource: LegacyDataSource? { source as? LegacyDataSource }
    
    init(source: LegacyDataSource) {
        self.source = source
        super.init(frame: .zero, collectionViewLayout: source.layout)
        
        dataSource = source
        delegate = source
        backgroundColor = .white
        
        register(LegacyCollectionCell.self, forCellWithReuseIdentifier: LegacyCollectionCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
