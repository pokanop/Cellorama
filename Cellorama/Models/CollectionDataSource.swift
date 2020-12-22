//
//  CollectionDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

class CollectionDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
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
    
    var maxItemWidth: CGFloat {
        guard let cell = cell,
              let superview = cell.superview,
              case .grid(let items) = container.layoutStyle else { return 0 }
        
        let width = container.maxWidth(for: superview.frame) - CGFloat(items - 1) * layout.minimumInteritemSpacing - container.insets.left - container.insets.right
        
        return width / CGFloat(items)
    }
    
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
        
        cell.source = self
        cell.containerViewController = containerViewController
        cell.configure(item: items[indexPath.row])
        
        return cell
    }
    
}
