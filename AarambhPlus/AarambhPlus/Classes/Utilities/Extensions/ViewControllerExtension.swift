//
//  ViewControllerExtension.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 10/3/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    //Make sure class name and storyboard identifier in IB must be same
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable {
    
    func switchToTab(_ item: TabBarItem) {
        if let tabBarController = UIApplication.shared.windows.first?.rootViewController as? TabBarController {
            tabBarController.switchTo(item)
        }
    }
    
    func showAlertView(_ title: String, message: String, cancelButtonTitle: String, otherButtonTitle: String, cancelHandler: ((UIAlertAction) -> Void)? = nil, otherOptionHandler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction.init(title: otherButtonTitle, style: .default, handler: otherOptionHandler)
        let cancelAction = UIAlertAction.init(title: cancelButtonTitle, style: .default, handler: cancelHandler)
        showAlert(actions: [cancelAction, alertAction], title: title, message: message)
    }
    
    func showAlertView(_ title: String, message: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alertAction = UIAlertAction.init(title: "Ok", style: .default, handler: handler)
        showAlert(actions: [alertAction], title: title, message: message)
    }
    
    func showAlert(actions: [UIAlertAction], title: String? = nil, message: String? = nil, type: UIAlertController.Style = .alert) {
        let alertController = UIAlertController.init(title: title, message: message, preferredStyle: type)
        actions.forEach { alertController.addAction($0) }
        alertController.view.tintColor = UIColor.appColor()
        alertController.preferredAction = actions.last
        self.present(alertController, animated: true, completion: nil)
    }
}
