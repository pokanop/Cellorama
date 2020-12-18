//
//  CollectionCell.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit
import SnapKit

class CollectionCell: UICollectionViewCell, Reusable {
    
    weak var containerViewController: UIViewController?
    var childViewController: UIViewController?
    var collectionView: CollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    func configure(item: Item) {
        configure(container: item.asContainer)
        configure(element: item.asElement)
    }
    
    func configure(container: Container?) {
        guard let container = container,
              let containerViewController = containerViewController else { return }
        
        let source = CollectionDataSource(container: container, containerViewController: containerViewController)
        let view = CollectionView(source: source)
        
        configure(view: view, for: container)
    }
    
    func configure(element: Element?) {
        guard let element = element else { return }
        
        let vc = ViewController(element: element)
        configure(viewController: vc)
    }
    
    func configure(view: CollectionView, for container: Container) {
        guard let containerViewController = containerViewController else { return }
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(999)
            make.width.equalTo(container.maxWidth(for: containerViewController.view.bounds))
        }
//        view.layoutIfNeeded()
        collectionView = view
    }
    
    func configure(viewController: UIViewController) {
        guard let containerViewController = containerViewController else { return }
        
        containerViewController.addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(999)
        }
        viewController.didMove(toParent: containerViewController)
        childViewController = viewController
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        childViewController?.willMove(toParent: nil)
        contentView.subviews.forEach { $0.removeFromSuperview() }
        childViewController?.removeFromParent()
        
        self.collectionView = nil
        self.childViewController = nil
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        guard let collectionView = collectionView else {
            return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        }

//        collectionView.frame = collectionView.bounds
//        collectionView.reloadData()
        collectionView.layoutIfNeeded()

        return collectionView.collectionViewLayout.collectionViewContentSize
    }
    
}
