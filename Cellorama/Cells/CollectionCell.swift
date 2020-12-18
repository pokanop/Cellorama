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
    var container: Container?
    var widthConstraint: Constraint?
    
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
        
        self.container = container
        configure(view: view)
    }
    
    func configure(element: Element?) {
        guard let element = element else { return }
        
        let vc = ViewController(element: element)
        configure(viewController: vc)
    }
    
    func configure(view: CollectionView) {
        guard let container = container else { return }
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(999)
            widthConstraint = make.width.equalTo(container.maxWidth(for: superview?.frame ?? .zero)).constraint
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
        self.container = nil
        self.widthConstraint = nil
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        guard let collectionView = collectionView,
              let container = container,
              let superview = superview,
              let widthConstraint = widthConstraint else {
            return super.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: horizontalFittingPriority, verticalFittingPriority: verticalFittingPriority)
        }
        
        widthConstraint.update(offset: container.maxWidth(for: superview.frame))
        
        collectionView.layoutIfNeeded()
//        collectionView.frame = collectionView.bounds
//        collectionView.reloadData()

        return collectionView.collectionViewLayout.collectionViewContentSize
    }
    
}
