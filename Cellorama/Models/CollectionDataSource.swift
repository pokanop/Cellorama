//
//  CollectionDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

final class CollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var container: Container
    var items: [Item] { container.items }
    var numberOfItems: Int { items.count }
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
        guard numberOfItems > indexPath.row else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        
        cell.containerViewController = containerViewController
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
    
}
