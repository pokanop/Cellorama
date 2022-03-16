//
//  CompositionalDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit
import SnapKit

final class CompositionalDataSource: CollectionSourceable {
    
    lazy var layout: UICollectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
        
        guard let self = self,
              self.container.items.count > sectionIndex,
              let container = self.container.items[sectionIndex].asContainer else { return nil }
        
        let section = NSCollectionLayoutSection(group: container.layoutGroup(with: layoutEnv))
        section.contentInsets = NSDirectionalEdgeInsets(top: container.insets.top,
                                                        leading: container.insets.left,
                                                        bottom: container.insets.bottom,
                                                        trailing: container.insets.right)
        if container.isCarousel {
            section.orthogonalScrollingBehavior = .continuous
        }
        section.interGroupSpacing = container.itemSpacing
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .estimated(44))
        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize,
                                                                 elementKind: SectionHeader.reuseIdentifier,
                                                                 alignment: .top)
        section.boundarySupplementaryItems = [header]
        section.supplementariesFollowContentInsets = false
        
        let decoration = NSCollectionLayoutDecorationItem.background(elementKind: SectionDecoration.reuseIdentifier)
        section.decorationItems = [decoration]
        
        return section
    }
    
    var container: Container
    weak var containerViewController: UIViewController?
    
    init(container: Container, containerViewController: UIViewController) {
        self.container = container
        self.containerViewController = containerViewController
        
        layout.register(SectionDecoration.self, forDecorationViewOfKind: SectionDecoration.reuseIdentifier)
    }
    
}

private extension Container {
    
    var zoneLayoutGroup: NSCollectionLayoutGroup {
        let size = NSCollectionLayoutSize(widthDimension: .estimated(50.0),
                                          heightDimension: .estimated(50.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        return NSCollectionLayoutGroup.vertical(layoutSize: size,
                                                subitems: [item])
    }
    
    var carouselLayoutGroup: NSCollectionLayoutGroup {
        let size = NSCollectionLayoutSize(widthDimension: .estimated(50.0),
                                          heightDimension: .estimated(50.0))
        let item = NSCollectionLayoutItem(layoutSize: size)
        return NSCollectionLayoutGroup.horizontal(layoutSize: size,
                                                  subitems: [item])
    }
    
    var gridLayoutGroup: NSCollectionLayoutGroup {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .estimated(50.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .estimated(50.0))
        return NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                  subitem: item,
                                                  count: Int(itemsPerRow))
    }
    
    func layoutGroup(with layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        var group: NSCollectionLayoutGroup
        switch layoutStyle {
        case .zone: group = zoneLayoutGroup
        case .carousel: group = carouselLayoutGroup
        case .grid: group = gridLayoutGroup
        case .stack: group = stackLayoutGroup(with: layoutEnv)
        case .tab: group = tabLayoutGroup(with: layoutEnv)
        }
        if layoutStyle != .stack {
            group.interItemSpacing = .fixed(itemSpacing)
        }
        return group
    }
    
    func stackLayoutGroup(with layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        let overlapHeight: CGFloat = 64.0
        let aspectRatio: CGFloat = 0.67
        let itemWidth = layoutEnv.container.contentSize.width - insets.left - insets.right
        let itemSize = CGSize(width: itemWidth, height: itemWidth * aspectRatio)
        
        let groupHeight = itemSize.height + (overlapHeight * CGFloat(items.count - 1))
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(groupHeight))
        
        return NSCollectionLayoutGroup.custom(layoutSize: groupSize) { layoutEnv in
            var items = [NSCollectionLayoutGroupCustomItem]()
            var yPos: CGFloat = 0
            for index in 0..<self.items.count {
                let frame = CGRect(x: 0, y: yPos,
                                   width: layoutEnv.container.contentSize.width - insets.left - insets.right,
                                   height: itemSize.height)
                let item = NSCollectionLayoutGroupCustomItem(frame: frame, zIndex: index)
                yPos += index == (self.items.count - 1) ? itemSize.height : overlapHeight
                items.append(item)
            }
            return items
        }
    }
    
    func tabLayoutGroup(with layoutEnv: NSCollectionLayoutEnvironment) -> NSCollectionLayoutGroup {
        let itemWidth = layoutEnv.container.contentSize.width - insets.left - insets.right
        let itemHeights = items.enumerated().filter { Int(CGFloat($0.offset) / CGFloat(items.count) * CGFloat(segmentCount)) == segmentIndex }.compactMap { $0.element.asElement?.heightInTab }
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(itemHeights.reduce(CGFloat(0), +)))
        
        return NSCollectionLayoutGroup.custom(layoutSize: groupSize) { env in
            var count: Int = 0
            var yPos: CGFloat = 0
            var items: [NSCollectionLayoutGroupCustomItem] = []
            for index in 0..<self.items.count {
                let frame: CGRect
                if Int(CGFloat(index) / CGFloat(self.items.count) * CGFloat(self.segmentCount)) == self.segmentIndex {
                    let height = itemHeights[count]
                    frame = CGRect(x: 0, y: yPos, width: itemWidth, height: height - itemSpacing)
                    yPos += height
                    count += 1
                } else {
                    frame = .zero
                }
                let item = NSCollectionLayoutGroupCustomItem(frame: frame)
                items.append(item)
            }
            return items
        }
    }
    
}

final class SectionHeader: UICollectionReusableView, Reusable {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(frame: .zero)
        segmentedControl.backgroundColor = .gray
        segmentedControl.addTarget(self, action: #selector(selectionChanged), for: .valueChanged)
        return segmentedControl
    }()
    
    var isTabHeader: Bool = false {
        didSet {
            guard let bottomConstraint = bottomConstraint else { return }
            isTabHeader ? bottomConstraint.deactivate() : bottomConstraint.activate()
            segmentedControl.isHidden = !isTabHeader
        }
    }
    
    var selectionAction: ((Int) -> ())? = nil
    var bottomConstraint: Constraint? = nil
    
    private var selectedIndex: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .separator
        
        addSubview(label)
        addSubview(segmentedControl)
        
        label.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8.0)
            bottomConstraint = make.bottom.equalToSuperview().inset(8.0).constraint
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview().inset(8.0)
            make.top.equalTo(label.snp.bottom).offset(8.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        label.text = nil
        isTabHeader = false
    }
    
    func setSegments(segments: [String], selectionIndex: Int = 0) {
        segmentedControl.removeAllSegments()
        for (index, segment) in segments.enumerated() {
            segmentedControl.insertSegment(withTitle: segment, at: index, animated: false)
        }
        segmentedControl.selectedSegmentIndex  = selectionIndex
        selectedIndex = selectionIndex
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc private func selectionChanged(segmentedControl: UISegmentedControl) {
        selectionAction?(segmentedControl.selectedSegmentIndex)
        selectedIndex = segmentedControl.selectedSegmentIndex
    }
    
}

private final class SectionDecoration: UICollectionReusableView, Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        updateBackgroundColor()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
//        updateBackgroundColor()
    }
    
    private func updateBackgroundColor() {
        let red   = CGFloat((arc4random() % 256)) / 255.0
        let green = CGFloat((arc4random() % 256)) / 255.0
        let blue  = CGFloat((arc4random() % 256)) / 255.0
        let alpha = CGFloat(1.0)

        backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
}
