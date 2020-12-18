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
//        let source = CollectionDataSource(container: Container(layoutStyle: .zone,
//                                                               items: [Container(layoutStyle: .carousel, items: randomElements(count: 20))],
//                                                               isRoot: true),
//                                          containerViewController: self)
        let source = CollectionDataSource(container: Container(items: randomItems(count: 10), isRoot: true), containerViewController: self)
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
