//
//  CollectionView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class CollectionView: UICollectionView {
    
    let source: CollectionDataSource
    
    override var intrinsicContentSize: CGSize { collectionViewLayout.collectionViewContentSize }
    
    init(source: CollectionDataSource) {
        self.source = source
        super.init(frame: .zero, collectionViewLayout: source.layout)
        
        dataSource = source
        delegate = source
        backgroundColor = .white
        
        register(CollectionCell.self, forCellWithReuseIdentifier: CollectionCell.reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

//        guard !bounds.size.equalTo(intrinsicContentSize) else { return }
//
//        invalidateIntrinsicContentSize()
        
        guard !source.container.isRoot else { return }
        
        frame = CGRect(x: 0, y: 0, width: contentSize.width, height: contentSize.height)
    }
    
}
