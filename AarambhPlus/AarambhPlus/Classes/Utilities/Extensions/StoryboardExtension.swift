//
//  StoryboardExtension.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 10/3/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum AppStoryboard: String {
    case home = "HomeScreen"
    case hamburger = "HamburgerMenu"
    case main = "Main"
    case launch = "LaunchScreen"
//    case profile = "Profile"
}

extension UIStoryboard {
    
    convenience init(_ storyboard: AppStoryboard, bundle: Bundle? = nil) {
        self.init(name: storyboard.rawValue, bundle: bundle)
    }
    
    static func storyboard(_ storyboard: AppStoryboard, bundle: Bundle? = nil) -> UIStoryboard {
        return  UIStoryboard(name: storyboard.rawValue, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>(withId: String = String(describing: T.self)) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: withId) as? T else {
            fatalError("Unable instantiate the view controller with identifier \(withId)")
        }
        return viewController
    }
}
