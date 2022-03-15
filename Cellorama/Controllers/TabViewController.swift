//
//  TabViewController.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit
import SnapKit

final class TabViewController: UIViewController {
    
    enum Style: Hashable {
        
        case zone
        case grid(Int)
        case carousel
        case stack
        case tab
        case mixed
        
        var layout: LayoutStyle {
            switch self {
            case .zone: return .zone
            case .grid(let items): return .grid(items)
            case .carousel: return .carousel
            case .stack: return .stack
            case .tab: return .tab
            case .mixed: return .random
            }
        }
        
        var name: String {
            switch self {
            case .mixed: return "Random"
            default: return layout.description.capitalized
            }
        }
        
        var image: UIImage {
            switch self {
            case .zone: return UIImage(systemName: "rectangle.grid.1x2.fill")!
            case .grid: return UIImage(systemName: "square.grid.2x2.fill")!
            case .carousel: return UIImage(systemName: "rectangle.split.3x1.fill")!
            case .stack: return UIImage(systemName: "rectangle.stack.fill")!
            case .tab: return UIImage(systemName: "rectangle.lefthalf.filled")!
            case .mixed: return UIImage(systemName: "rectangle.3.offgrid.fill")!
            }
        }
        
        static func == (lhs: Style, rhs: Style) -> Bool {
            lhs.name == rhs.name
        }
        
        func source(controller: UIViewController) -> CollectionSourceable {
            var containers: [AnyItem]
            if self == .mixed {
                var layout: LayoutStyle?
                switch options.size {
                case .small: layout = .zone
                case .medium: layout = .grid(2)
                case .large: layout = .carousel
                default: break
                }
                containers = randomContainers(count: options.sections,
                                              style: layout)
            } else {
                containers = Cellorama.containers(count: options.sections,
                                                  style: layout,
                                                  size: options.size)
            }
            let container: Container = Container(layoutStyle: .zone,
                                                 items: containers,
                                                 isRoot: true)
            if options.isLegacy {
                return LegacyDataSource(container: container,
                                        containerViewController: controller)
            } else {
                return CompositionalDataSource(container: container,
                                               containerViewController: controller)
            }
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(name)
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
    
    lazy var optionsView: OptionsView = OptionsView(style: style)
    var collectionView: CollectionView!
    var style: Style
    var optionsTopConstraint: Constraint?
    
    init(style: Style) {
        self.style = style
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        title = style.name
        view.backgroundColor = .white
        
        options.updateHandler = { [weak self] option in
            guard let self = self else { return }
            
            switch option {
            case .animate: self.collectionView.optionUpdated(.animate)
            case .transitions: self.collectionView.optionUpdated(.transitions)
            case .legacy: self.setupCollectionView()
            case .sections: self.collectionView.optionUpdated(.sections)
            case .items: self.collectionView.optionUpdated(.items)
            case .size: self.collectionView.optionUpdated(.size)
            case .columns:
                self.collectionView.optionUpdated(.columns)
                if case .grid = self.style {
                    self.style = .grid(options.columns)
                    currentTabStyle = self.style
                }
            }
        }
        
        setupOptionsView()
        setupCollectionView()
        collectionView.applyLayout()
        
        let rightItems: [UIBarButtonItem] = [
            UIBarButtonItem(image: UIImage(systemName: "gearshape.fill")!, style: .plain, target: self, action: #selector(optionsSelected)),
        ]
        navigationItem.setRightBarButtonItems(rightItems, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateOptionsTopConstraint(animated: false)
    }
    
    @objc func optionsSelected() {
        optionsView.visible.toggle()
        updateOptionsTopConstraint()
    }
    
    private func updateSource() {
        collectionView.source = style.source(controller: self)
        collectionView.applyLayout()
        collectionView.applySnapshot()
    }
    
    private func updateOptionsTopConstraint(animated: Bool = true) {
        self.optionsTopConstraint?.update(offset: self.optionsView.visible ? 0 : -self.optionsView.frame.height)
        
        guard animated else { return }
        
        UIView.animate(withDuration: 0.3, delay: 0) {
            self.view.layoutIfNeeded()
        }

    }
    
    private func setupOptionsView() {
        self.view.addSubview(optionsView)
        optionsView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            optionsTopConstraint = make.top.equalToSuperview().constraint
        }
    }
    
    private func setupCollectionView() {
        if let collectionView = collectionView {
            collectionView.removeFromSuperview()
        }
        
        var view: CollectionView
        if options.isLegacy {
            let source = LegacyDataSource(container: Container(),
                                          containerViewController: self)
            view = LegacyCollectionView(source: source)
        } else {
            let source = CompositionalDataSource(container: Container(),
                                                 containerViewController: self)
            view = CompositionalCollectionView(source: source)
        }
        collectionView = view
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(optionsView.snp.bottom)
        }
        
        updateSource()
    }

}

var currentTabStyle: TabViewController.Style = .zone
