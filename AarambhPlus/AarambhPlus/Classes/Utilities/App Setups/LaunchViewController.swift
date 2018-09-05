//
//  LaunchViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class LaunchViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        createTabBarItems()
    }

}

private extension LaunchViewController {
    
    func createTabBarItems() {
        let barItems:[TabBarItemType] = [.home,.movies,.search,.more]
        var controllers = [UIViewController]()
        for item in barItems {
            switch item {
            case .home:
                let vc = HomeScreenController.controller()
                vc.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home_tab"), selectedImage: #imageLiteral(resourceName: "Home_tab"))
                controllers.append(vc)
            case .movies:
                let vc = HomeScreenController.controller()
                vc.tabBarItem = UITabBarItem(title: "Movies", image: #imageLiteral(resourceName: "Movie_tab"), selectedImage: #imageLiteral(resourceName: "Movie_tab"))
                controllers.append(vc)
            case .search:
                let vc = HomeScreenController.controller()
                vc.tabBarItem = UITabBarItem(title: "Search", image: #imageLiteral(resourceName: "Search_tab"), selectedImage: #imageLiteral(resourceName: "Search_tab"))
                controllers.append(vc)
            case .more:
                let vc = HomeScreenController.controller()
                vc.tabBarItem = UITabBarItem(title: "Profile", image: #imageLiteral(resourceName: "Home_tab"), selectedImage: #imageLiteral(resourceName: "Home_tab"))
                controllers.append(vc)
            }
        }
        let tabBar = TabBarController()
        tabBar.viewControllers = controllers
        appDelegate?.window??.rootViewController = APNavigationController(rootViewController: tabBar)
        
    }
}
