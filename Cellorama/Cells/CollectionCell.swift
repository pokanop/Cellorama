//
//  CollectionCell.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit
import SnapKit

class CollectionCell: UICollectionViewCell, Reusable {
    
    weak var source: LegacyDataSource?
    weak var containerViewController: UIViewController?
    var childViewController: ViewController?
    var collectionView: CollectionView?
    var parent: Container?
    var container: Container?
    var element: Element?
    var heightConstraint: Constraint?
    var widthConstraint: Constraint?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if layer.shadowOpacity > 0 {
            layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        }
    }
    
    func configure(item: AnyItem, parent: Container) {
        self.parent = parent
        configure(container: item.asContainer)
        configure(element: item.asElement)
    }
    
    func configure(container: Container?) {
        guard let container = container,
              let containerViewController = containerViewController else { return }
        
        let source = LegacyDataSource(container: container, containerViewController: containerViewController)
        let view = LegacyCollectionView(source: source)
        
        self.container = container
        configure(view: view)
    }
    
    func configure(element: Element?) {
        guard let element = element else { return }
        
        let vc = ViewController(element: element)
        self.element = element
        configure(viewController: vc)
    }
    
    func configure(view: CollectionView) {
        guard let parent = parent else { return }
        
        applyShadow(to: layer)
        applyCorner(to: contentView.layer)
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview().priority(999)
            heightConstraint = make.height.equalTo(CGFloat.greatestFiniteMagnitude).priority(999).constraint
            widthConstraint = make.width.equalTo(parent.maxWidth(for: superview?.frame ?? .zero)).constraint
        }
        collectionView = view
    }
    
    func configure(viewController: ViewController) {
        guard let parent = parent,
              let containerViewController = containerViewController else { return }
        
        containerViewController.addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            if parent.isGrid {
                make.center.equalToSuperview()
            }
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
        self.heightConstraint = nil
        self.widthConstraint = nil
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize,
                                          withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
                                          verticalFittingPriority: UILayoutPriority) -> CGSize {
        guard let source = source,
              let parent = parent else { return .zero }
        
        var size: CGSize
        
        guard let collectionView = collectionView,
              let container = container,
              let superview = superview,
              let widthConstraint = widthConstraint else {
            // Element sizing
            guard let element = element else { return targetSize }
            
            let cachedSize = sizeCache.size(for: element.identifier)
            if !cachedSize.equalTo(.zero) {
                return cachedSize
            }
            
            size = super.systemLayoutSizeFitting(targetSize,
                                                     withHorizontalFittingPriority: horizontalFittingPriority,
                                                     verticalFittingPriority: verticalFittingPriority)

            if parent.isGrid {
                size.width = max(size.width, parent.maxItemWidth(for: bounds, minimumInteritemSpacing: source.flowLayout.minimumInteritemSpacing))
            }
            
            sizeCache.setMaxHeight(size.height, for: parent.identifier)
            sizeCache.setSize(size, for: element.identifier)
            
            heightConstraint?.update(offset: size.height)
            
            return size
        }
        
        // Container sizing
        let cachedSize = sizeCache.size(for: container.identifier)
        if !cachedSize.equalTo(.zero) {
            return cachedSize
        }
        
        widthConstraint.update(offset: container.maxWidth(for: superview.frame))
        
        collectionView.frame = bounds
        collectionView.layoutIfNeeded()
        
        size = collectionView.collectionViewLayout.collectionViewContentSize
        if container.layoutStyle == .carousel {
            size.height = sizeCache.maxHeight(for: container.identifier, with: container)
            size.width = collectionView.frame.width
        }
        
        sizeCache.setSize(size, for: container.identifier)
        heightConstraint?.update(offset: size.height)
        
        return size
    }
    
}
