//
//  HamburgerMenuController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/6/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum HamburgerCellType: Int {
    case profile = 0, item
}

class HamburgerMenuController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    class func controller() -> HamburgerMenuController {
        let controller = UIStoryboard(name: "HamburgerMenu", bundle: nil).instantiateViewController(withIdentifier: "\(HamburgerMenuController.self)") as! HamburgerMenuController
        controller.modalPresentationStyle = .custom
        controller.transitioningDelegate = controller
        return controller
    }
    
    @IBAction func dismissOnTap(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension HamburgerMenuController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == HamburgerCellType.profile.rawValue {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerProfileCell", for: indexPath) as! HamburgerProfileCell
            cell.updateUI()
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerItemCell", for: indexPath) as! HamburgerItemCell
            return cell
        }
    }
}

extension HamburgerMenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == HamburgerCellType.profile.rawValue {
            if UserManager.shared.isLoggedIn {
                self.performSelector(onMainThread: #selector(pushProfileScreen), with: nil, waitUntilDone: false)
            } else {
                self.performSelector(onMainThread: #selector(pushLoginScreen), with: nil, waitUntilDone: false)
            }
        }
    }
}

private extension HamburgerMenuController {
    @objc func pushLoginScreen() {
        dismiss(animated: true) {
            (appDelegate?.window??.rootViewController  as? APNavigationController)?.pushViewController(LoginController.controller(), animated: true)
        }
    }
    
    @objc func pushProfileScreen() {
        dismiss(animated: true) {
            (appDelegate?.window??.rootViewController  as? APNavigationController)?.pushViewController(ProfileDetailViewController.controller(), animated: true)
        }
    }
}

extension HamburgerMenuController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SidePanelCustomTransitionAnimator()
        animator.duration = 0.4
        return animator
    }
    
    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SidePanelCustomTransitionAnimator()
        animator.duration = 0.4
        return animator
    }
}
