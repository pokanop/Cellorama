//
//  TabViewController.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit
import SnapKit

final class TabViewController: UIViewController {
    
    enum Style: Equatable {
        
        case zone
        case grid(Int)
        case carousel
        case mixed
        
        var layout: LayoutStyle {
            switch self {
            case .zone: return .zone
            case .grid(let items): return .grid(items)
            case .carousel: return .carousel
            case .mixed: return .random
            }
        }
        
        var name: String {
            switch self {
            case .zone: return "Zone"
            case .grid: return "Grid"
            case .carousel: return "Carousel"
            case .mixed: return "Random"
            }
        }
        
        var image: UIImage {
            switch self {
            case .zone: return UIImage(systemName: "rectangle.grid.1x2.fill")!
            case .grid: return UIImage(systemName: "square.grid.2x2.fill")!
            case .carousel: return UIImage(systemName: "rectangle.split.3x1.fill")!
            case .mixed: return UIImage(systemName: "rectangle.3.offgrid.fill")!
            }
        }
        
        func source(count: Int, size: View.Size, controller: UIViewController) -> CollectionDataSource {
            let containers = Cellorama.containers(count: count,
                                                  style: layout,
                                                  size: size)
            let container: Container = Container(layoutStyle: .zone,
                                                 items: containers,
                                                 isRoot: true)
            return CollectionDataSource(container: container,
                                        containerViewController: controller)
        }
        
    }
    
    enum Mode {
        
        case small
        case medium
        case large
        case xlarge
    
        var image: UIImage {
            switch self {
            case .small: return UIImage(systemName: "1.circle")!
            case .medium: return UIImage(systemName: "2.circle")!
            case .large: return UIImage(systemName: "3.circle")!
            case .xlarge: return UIImage(systemName: "4.circle")!
            }
        }
    }
    
    lazy var collectionView: CollectionView = {
        let source = CollectionDataSource(container: Container(),
                                          containerViewController: self)
        let view = CollectionView(source: source)
        return view
    }()
    
    let style: Style
    let count: Int
    
    init(style: Style, count: Int = 10) {
        self.style = style
        self.count = count
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = style.name
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let leftItems: [UIBarButtonItem] = [
            UIBarButtonItem(image: Mode.small.image, style: .plain, target: self, action: #selector(smallSelected)),
            UIBarButtonItem(image: Mode.medium.image, style: .plain, target: self, action: #selector(mediumSelected))
        ]
        let rightItems: [UIBarButtonItem] = [
            UIBarButtonItem(image: Mode.xlarge.image, style: .plain, target: self, action: #selector(xlargeSelected)),
            UIBarButtonItem(image: Mode.large.image, style: .plain, target: self, action: #selector(largeSelected))
        ]
        navigationItem.setLeftBarButtonItems(leftItems, animated: true)
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
        
        smallSelected()
    }
    
    @objc func smallSelected() {
        collectionView.source = style.source(count: count, size: .small, controller: self)
    }
    
    @objc func mediumSelected() {
        collectionView.source = style.source(count: count, size: .medium, controller: self)
    }
    
    @objc func largeSelected() {
        collectionView.source = style.source(count: count, size: .large, controller: self)
    }
    
    @objc func xlargeSelected() {
        collectionView.source = style.source(count: count, size: .xlarge, controller: self)
    }

}
