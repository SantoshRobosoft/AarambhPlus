//
//  LaunchViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit


/// This controller will 1st get call from app delegate method (didfinish )
class LaunchViewController: BaseViewController {

    var isProfileInfoFetched = false
    override func viewDidLoad() {
        super.viewDidLoad()
        CustomLoader.addLoaderOn(self.view, gradient: false)
//        fetchUserInfo()
    }

    class func controller() -> LaunchViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "\(LaunchViewController.self)") as! LaunchViewController
    }
}

private extension LaunchViewController {
        
    /// sdfsfsdfsd
    func createTabBarItems() {
//        let barItems:[TabBarItemType] = [.home, .music, .originals, .jatra, .movies]
//        var controllers = [UIViewController]()
//        for item in barItems {
//            switch item {
//            case .home:
//                let vc = HomeScreenController.controller()
//                vc.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "Home_tab"), selectedImage: #imageLiteral(resourceName: "Home_tab"))
//                vc.title = "Home"
//                controllers.append(vc)
//            case .music:
//                let vc = VideoListController.controller()
//                vc.tabBarItem = UITabBarItem(title: "Music", image: #imageLiteral(resourceName: "Movie_tab"), selectedImage: #imageLiteral(resourceName: "Movie_tab"))
//                controllers.append(vc)
//            case .originals:
//                let vc = VideoListController.controller()
//                vc.tabBarItem = UITabBarItem(title: "Original", image: #imageLiteral(resourceName: "Search_tab"), selectedImage: #imageLiteral(resourceName: "Search_tab"))
//                controllers.append(vc)
//            case .jatra:
//                let vc = HomeScreenController.controller()
//                vc.tabBarItem = UITabBarItem(title: "Jatra", image: #imageLiteral(resourceName: "Home_tab"), selectedImage: #imageLiteral(resourceName: "Home_tab"))
//                controllers.append(vc)
//            case .movies:
//                let vc = VideoListController.controller()
//                vc.tabBarItem = UITabBarItem(title: "Movies", image: #imageLiteral(resourceName: "Search_tab"), selectedImage: #imageLiteral(resourceName: "Search_tab"))
//                controllers.append(vc)
//            }
//        }
//
//        let tabBar = TabBarController()
//        tabBar.viewControllers = controllers
//        CustomLoader.removeLoaderFrom(self.view)
//        appDelegate?.window??.rootViewController = APNavigationController(rootViewController: tabBar)
//        
    }
}
