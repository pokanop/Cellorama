//
//  CompositionalDataSource.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit

final class CompositionalDataSource: CollectionSourceable {
    
    lazy var layout: UICollectionViewLayout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnv in
        
        guard let self = self,
              self.container.items.count > sectionIndex,
              let container = self.container.items[sectionIndex].asContainer else { return nil }
        
        let section = NSCollectionLayoutSection(group: container.layoutGroup)
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
        
        layout.register(SectionHeader.self, forDecorationViewOfKind: SectionHeader.reuseIdentifier)
        layout.register(SectionDecoration.self, forDecorationViewOfKind: SectionDecoration.reuseIdentifier)
    }
    
}

private extension Container {
    
    var layoutGroup: NSCollectionLayoutGroup {
        var group: NSCollectionLayoutGroup
        switch layoutStyle {
        case .zone: group = zoneLayoutGroup
        case .carousel: group = carouselLayoutGroup
        case .grid: group = gridLayoutGroup
        }
        group.interItemSpacing = .fixed(itemSpacing)
        return group
    }
    
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
    
}

final class SectionHeader: UICollectionReusableView, Reusable {
    
    let label: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .separator
        
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8.0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
