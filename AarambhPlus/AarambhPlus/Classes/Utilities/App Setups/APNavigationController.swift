//
//  APNavigationController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/5/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class APNavigationController: UINavigationController {

    var hambergerButton: UIBarButtonItem?
    var backButton: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
//        navigationBar.backgroundColor = UIColor.appColor()
        createHambergerButton()
        createBackButton()
        /*******************************Navigation Bar Gradient Colour************************************/
        let gradient = CAGradientLayer()
        let defaultNavigationBarFrame = navigationBar.frame
        gradient.frame = defaultNavigationBarFrame
        let colorBottom = UIColor.colorRGB(255, g: 200, b: 55).cgColor
        let colorTop = UIColor.colorRGB(255, g: 128, b: 8).cgColor
        gradient.colors = [colorTop, colorBottom]
        UINavigationBar.appearance().barTintColor = UIColor.appColor()//setBackgroundImage(image(fromLayer: gradient), for: .default)
    }
    
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

private extension APNavigationController {
    
    @objc func backButtonClicked(_ sender: UIBarButtonItem) {
        self.popViewController(animated: true)
    }
    
    @objc func hambergerButtonClicked(_ sender: UIBarButtonItem) {
        let controller = HamburgerMenuController.controller()
        
        present(controller, animated: true, completion: nil)
    }
    
    func createHambergerButton() {
        self.hambergerButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Hamburger_menu"),
                                               style: UIBarButtonItemStyle.plain,
                                               target: self,
                                               action: #selector(APNavigationController.hambergerButtonClicked(_:)))
        hambergerButton?.tintColor = UIColor.black
    }
    
    func createBackButton() {
        self.backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "back_nav"),
                                          style: UIBarButtonItemStyle.plain,
                                          target: self,
                                          action: #selector(APNavigationController.backButtonClicked(_:)))
        backButton?.tintColor = UIColor.black
    }
}

extension APNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count <= 1 {
            viewController.navigationItem.leftBarButtonItem = self.hambergerButton
            tabBarController?.tabBar.isHidden = false
        } else {
            tabBarController?.tabBar.isHidden = true
            viewController.navigationItem.leftBarButtonItem = self.backButton
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if navigationController.viewControllers.count <= 1 {
            tabBarController?.tabBar.isHidden = false
            viewController.navigationItem.leftBarButtonItem = self.hambergerButton
        } else {
            tabBarController?.tabBar.isHidden = true
            viewController.navigationItem.leftBarButtonItem = self.backButton
        }
    }
}
/*******************************Navigation Bar Gradient Colour************************************/
func image(fromLayer layer: CALayer) -> UIImage {
    UIGraphicsBeginImageContext(layer.frame.size)
    layer.render(in: UIGraphicsGetCurrentContext()!)
    let outputImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return outputImage!
}
