//
//  TabBarController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum TabBarItemType {
    case home, music, originals, jatra, movies
}

class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        let layerGradient = CAGradientLayer()
        super.viewDidLoad()
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
