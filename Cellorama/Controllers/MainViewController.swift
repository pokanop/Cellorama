//
//  MainViewController.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/16/20.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    lazy var collectionView: CollectionView = {
        var items: [Item] = []
        for _ in 1...100 { items.append(Element()) }
        let container = Container(items: items)
        let source = CollectionDataSource(container: container, containerViewController: self)
        let view = CollectionView(source: source)
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Cellorama"
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
