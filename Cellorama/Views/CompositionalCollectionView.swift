//
//  CompositionalCollectionView.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/17/22.
//

import Foundation
import UIKit

final class CompositionalCollectionView: UICollectionView, CollectionViewable {
    
    var source: CollectionSourceable
    
    private var compositionalSource: CompositionalDataSource? { source as? CompositionalDataSource }
    
    private var uiDataSource: UICollectionViewDiffableDataSource<Container, Element>?
    
    private var animationType: AnimationType = .moveItems
    private var animationTimer: Timer? = nil
    private var animate: Bool = false {
        didSet {
            guard animate else {
                animationTimer?.invalidate()
                return
            }
            
            animationTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true, block: { [weak self] _ in
                guard let self = self else { return }
                
                self.animationType = self.animationType.next
                if options.transitions {
                    self.invalidateLayout()
                }
                self.source.randomize(self.animationType,
                                      transitionContainers: options.transitions)
                self.applySnapshot()
            })
        }
    }
    
    init(source: CollectionSourceable) {
        self.source = source
        super.init(frame: .zero, collectionViewLayout: source.layout)
        
        backgroundColor = .white
        
        register(SectionHeader.self,
                 forSupplementaryViewOfKind: SectionHeader.reuseIdentifier,
                 withReuseIdentifier: SectionHeader.reuseIdentifier)
        register(CompositionalCollectionCell.self,
                 forCellWithReuseIdentifier: CompositionalCollectionCell.reuseIdentifier)
        
        makeDiffableDataSource(using: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeDiffableDataSource(using collectionView: UICollectionView) {
        uiDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self,
                  let element = self.container.items[indexPath.section].asContainer?.items[indexPath.row].asElement,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CompositionalCollectionCell.reuseIdentifier, for: indexPath) as? CompositionalCollectionCell else { return nil }
            cell.containerViewController = self.compositionalSource?.containerViewController
            cell.container = self.container.items[indexPath.section].asContainer
            cell.configure(element: element)
            return cell
        }
        uiDataSource?.supplementaryViewProvider = { view, kind, indexPath in
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: SectionHeader.reuseIdentifier, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as? SectionHeader,
                  let container = self.container.items[indexPath.section].asContainer else { fatalError() }
            
            header.label.text = "\(String(describing: container.layoutStyle).capitalized) \(indexPath.section)"
            return header
        }
    }
    
    func invalidateLayout() {
        collectionViewLayout.invalidateLayout()
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.layoutIfNeeded()
        }
    }
    
    func applyLayout() {
        setCollectionViewLayout(source.layout, animated: true)
    }
    
    func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Container, Element>()
        let containers = container.items.compactMap { $0.asContainer }
        snapshot.appendSections(containers)
        containers.forEach { container in
            snapshot.appendItems(container.items.compactMap { $0.asElement }, toSection: container)
        }
        uiDataSource?.apply(snapshot)
    }
    
    func optionUpdated(_ kind: Options.Kind) {
        switch kind {
        case .animate:
            animate = options.animate
        case .sections:
            source.updateSectionCount(options.sections)
            applySnapshot()
        case .items:
            source.updateItemCount(options.items)
            applySnapshot()
        case .size:
            source.updateSize(options.size)
            applySnapshot()
        case .columns:
            source.updateColumnCount(options.columns)
            invalidateLayout()
        default:
            return
        }
    }
    
}
