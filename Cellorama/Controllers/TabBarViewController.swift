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
        
        optionsMap[.zone]?.size = .xlarge
        optionsMap[.grid(0)]?.columns = 5
        optionsMap[.carousel]?.size = .medium
        optionsMap[.stack]?.size = .dynamic
        optionsMap[.tab]?.size = .dynamic
        
        let zonesController = TabViewController(style: .zone)
        let gridController = TabViewController(style: .grid(5))
        let carouselController = TabViewController(style: .carousel)
        let stackController = TabViewController(style: .stack)
        let tabController = TabViewController(style: .tab)
//        let mixedController = TabViewController(style: .mixed)
        
        let tabs = [
            zonesController,
            gridController,
            carouselController,
            stackController,
            tabController,
//            mixedController
        ]
        let navs = tabs.map { UINavigationController(rootViewController: $0) }
        tabs.forEach { tab in
            tab.tabBarItem = UITabBarItem(title: tab.style.name,
                                          image: tab.style.image,
                                          tag: 0)
        }
        
        setViewControllers(navs, animated: false)
        delegate = self
        
        UITabBar.appearance().backgroundColor = .white
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navs.forEach { nav in
            nav.navigationBar.standardAppearance = appearance
            nav.navigationBar.scrollEdgeAppearance = appearance
        }
    }
    
}

extension TabBarViewController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let tabViewController = (viewController as? UINavigationController)?.viewControllers[0] as? TabViewController else { return }
        
        currentTabStyle = tabViewController.style
    }
    
}
