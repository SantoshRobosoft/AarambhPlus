//
//  TabBarController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum TabBarItem: Int {
    case home
    case music
    case originals
    case jatra
    case movies
    
    func getTitleAndImage() -> (String, UIImage) {
        switch self {
        case .home:
            return ("Home", #imageLiteral(resourceName: "home"))
        case .music:
            return ("Music", #imageLiteral(resourceName: "musical_notes"))
        case .originals:
            return ("Originals", #imageLiteral(resourceName: "play"))
        case .jatra:
            return ("Jatra",#imageLiteral(resourceName: "video_call"))
        case .movies:
            return ("Movies",#imageLiteral(resourceName: "Movie"))
        }
    }
    
    func getController() -> UIViewController {
        switch self {
        case .home:
            return UIStoryboard.init(.home).instantiateViewController(withIdentifier: HomeScreenController.storyboardIdentifier)
        case .music:
            return UIStoryboard.init(.home).instantiateViewController(withId: MusicViewController.storyboardIdentifier)
        case .originals:
            return UIStoryboard.init(.home).instantiateViewController(withId: HomeScreenController.storyboardIdentifier)
        case .jatra:
            return UIStoryboard.init(.home).instantiateViewController(withIdentifier: HomeScreenController.storyboardIdentifier)
        case .movies:
            return UIStoryboard.init(.home).instantiateViewController(withId: HomeScreenController.storyboardIdentifier)
        }
    }
    
    func getTabControllerAtIndex(_ index: Int) -> UIViewController {
        let controller = getController()
        let (title, image) = getTitleAndImage()
        controller.tabBarItem = UITabBarItem.init(title: title, image: image, tag: index)
        return controller
    }
    
    static func tabBarItems() -> [TabBarItem] {
        var items: [TabBarItem] = []
        items.append(.home)
        items.append(.music)
        items.append(.originals)
        items.append(.jatra)
        items.append(.movies)
        return items
    }
    
    static var selectedTab: TabBarItem {
        guard let tabBarController = UIViewController.tabBarVC else {
            return .home
        }
        let index = tabBarController.selectedIndex
        return TabBarItem.tabBarItems()[index]
    }
}

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        createTabBarItems()
        fetchUserInfo()
    }
    
    func fetchUserInfo() {
        DispatchQueue.global().async {
            if let userId = UserDefaults.standard.value(forKey: kSavedUserId) as? String, let email = UserDefaults.standard.value(forKey: kSavedUserEmail) as? String {
                NetworkManager.getUserInfo(email: email, userId: userId) { (result) in
                    if let user = result.response?.data {
                        DispatchQueue.main.async {
                            UserManager.shared.updateUser(user)
                        }
                    }
                }
            }
        }
    }
    
    func createTabBarItems() {
        var controllersList: [UIViewController] = []
        for item in TabBarItem.tabBarItems().enumerated() {
            let viewController = item.element.getTabControllerAtIndex(item.offset)
            controllersList.append(viewController)
        }
        self.viewControllers = controllersList.map { APNavigationController(rootViewController: $0) }
    }
    
    func switchTo(_ tab: TabBarItem) {
        self.selectedIndex = tab.rawValue
    }
    
    func addGradient() {
        let layerGradient = CAGradientLayer()
        /*******************************Tab Bar Gradient Colour************************************/
        let colorTop = UIColor.colorRGB(255, g: 200, b: 55).cgColor
        let colorBottom = UIColor.colorRGB(255, g: 128, b: 8).cgColor
        layerGradient.colors = [colorTop, colorBottom]
        layerGradient.locations = [0.0, 1.0]
        
        layerGradient.startPoint = CGPoint(x: 0, y: 0.5)
        layerGradient.endPoint = CGPoint(x: 1, y: 0.5)
        layerGradient.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        self.tabBar.layer.addSublayer(layerGradient)
        
        /*******************************Tab Bar Image Colour************************************/
        let selectedColor   = UIColor(red: 255.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        let unselectedColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        UITabBar.appearance().tintColor = selectedColor
        UITabBar.appearance().unselectedItemTintColor = unselectedColor
    }
}
