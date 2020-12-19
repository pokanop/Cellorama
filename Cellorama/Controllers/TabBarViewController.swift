//
//  TabBarViewController.swift
//  Cellorama
//
//  Created by Sahel Jalal on 12/17/20.
//

import UIKit

final class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let zonesController = TabViewController(style: .zone)
        let gridController = TabViewController(style: .grid(2))
        let carouselController = TabViewController(style: .carousel)
        let mixedController = TabViewController(style: .mixed)
        
        let tabs = [zonesController,
                    gridController,
                    carouselController,
                    mixedController]
        let navs = tabs.map { UINavigationController(rootViewController: $0) }
        tabs.forEach { tab in
            tab.tabBarItem = UITabBarItem(title: tab.style.name,
                                          image: tab.style.image,
                                          tag: 0)
        }
        
        setViewControllers(navs, animated: true)
    }
    
}
