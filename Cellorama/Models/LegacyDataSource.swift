//
//  LegacyDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class LegacyDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, CollectionSourceable {
    
    lazy var layout: UICollectionViewLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = container.itemSpacing
        layout.sectionInset = container.insets
        layout.scrollDirection = container.layoutStyle == .carousel ? .horizontal : .vertical
        return layout
    }()
    
    var flowLayout: UICollectionViewFlowLayout! { layout as? UICollectionViewFlowLayout }
    
    var container: Container
    weak var containerViewController: UIViewController?
    
    init(container: Container, containerViewController: UIViewController) {
        self.container = container
        self.containerViewController = containerViewController
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard numberOfItems > indexPath.item else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LegacyCollectionCell.reuseIdentifier, for: indexPath) as? LegacyCollectionCell else { return UICollectionViewCell() }
        cell.source = self
        cell.containerViewController = containerViewController
        cell.configure(item: items[indexPath.item], parent: container)
        
        return cell
    }
    
}
