//
//  CompositionalCollectionCell.swift
//  Cellorama
//
//  Created by Sahel Jalal on 2/18/22.
//

import UIKit

final class CompositionalCollectionCell: UICollectionViewCell, Reusable {
    
    var container: Container?
    var element: Element?
    var childViewController: ViewController?
    weak var containerViewController: UIViewController?
    
    func configure(element: Element?) {
        guard let element = element else { return }
        
        let vc = ViewController(element: element)
        self.element = element
        configure(viewController: vc)
    }
    
    func configure(viewController: ViewController) {
        guard let container = container,
              let containerViewController = containerViewController else { return }
        
        containerViewController.addChild(viewController)
        contentView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { make in
            if container.isGrid {
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
        
        self.childViewController = nil
        self.container = nil
    }
    
}
