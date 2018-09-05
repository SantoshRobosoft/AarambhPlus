//
//  APNavigationController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class APNavigationController: UINavigationController {

    func setRootViewController(_ controller: UIViewController, animated: Bool) {
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: true)
        if self.viewControllers.count > 1 {
            tabBarController?.tabBar.isHidden = true
        } else {
            tabBarController?.tabBar.isHidden = false
        }
    }
}
