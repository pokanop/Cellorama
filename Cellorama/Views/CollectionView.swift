//
//  CollectionView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class CollectionView: UICollectionView {
    
    var source: CollectionDataSource {
        didSet {
            DispatchQueue.main.async {
                self.collectionViewLayout = self.source.layout
                self.dataSource = self.source
                self.delegate = self.source
                self.reloadData()
            }
        }
    }
    
    var container: Container { source.container }
    
//    override var intrinsicContentSize: CGSize { collectionViewLayout.collectionViewContentSize }
    
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
        
        guard !container.isRoot else { return }
        
        
        var height: CGFloat
        var width: CGFloat
        
        if container.layoutStyle == .carousel {
            height = source.maxItemHeight
            width = frame.width
        } else {
            height = contentSize.height
            width = contentSize.width
        }
        
        frame = CGRect(x: frame.origin.x,
                       y: frame.origin.y,
                       width: width > 0 ? width : frame.height,
                       height: height > 0 ? height : frame.width)
        
    }
    
}
