//
//  CollectionDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

final class CollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    lazy var layout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumInteritemSpacing = container.itemSpacing
        layout.sectionInset = container.insets
        layout.scrollDirection = container.layoutStyle == .carousel ? .horizontal : .vertical
        return layout
    }()
    
    var container: Container
    var items: [Item] { container.items }
    var numberOfItems: Int { items.count }
    weak var containerViewController: UIViewController?
    weak var cell: CollectionCell?
    
    var maxItemHeight: CGFloat {
        get { container.maxItemHeight }
        set {
            guard maxItemHeight != newValue else { return }
            
            container.maxItemHeight = container.maxHeight(for: newValue)
            cell?.heightConstraint?.update(offset: maxItemHeight)
        }
    }
    
    init(container: Container, containerViewController: UIViewController) {
        self.container = container
        self.containerViewController = containerViewController
        super.init()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("### \(container.layoutStyle) num items \(numberOfItems)")
        return numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("### \(container.layoutStyle) dequeuing cell \(indexPath)")
        guard numberOfItems > indexPath.row else { return UICollectionViewCell() }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCell.reuseIdentifier, for: indexPath) as? CollectionCell else { return UICollectionViewCell() }
        print("### \(container.layoutStyle) configuring cell \(indexPath)")
        cell.source = self
        cell.containerViewController = containerViewController
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
    
}
