//
//  HamburgerMenuController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/6/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum HamburgerCellType: Int {
    case profile = 0, items
}

class HamburgerMenuController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    var items = ["Dashboard", "Music", "Originals", "Jatra", "Movies"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !items.contains("Log Out") {
            if UserManager.shared.isLoggedIn {
                items.append("My Favorites")
                items.append("My Profile")
                items.append("Log Out")
            } else {
                for (index, item) in items.enumerated() {
                    if item == "Log Out" {
                        items.remove(at: index)
                        return
                    }
                }
            }
        }
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
        return 2//HamburgerCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let type = HamburgerCellType(rawValue: section) {
            switch type {
            case .profile:
                return 1
            case .items:
                return items.count
            }
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let type = HamburgerCellType(rawValue: indexPath.section) {
            switch type {
            case .profile:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerProfileCell", for: indexPath) as! HamburgerProfileCell
                cell.updateUI()
                return cell
            case .items:
                let cell = tableView.dequeueReusableCell(withIdentifier: "HamburgerItemCell", for: indexPath) as! HamburgerItemCell
                cell.updateUI(title: items[indexPath.row])
                return cell
            }
        }
        return UITableViewCell()
    }
}

extension HamburgerMenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == HamburgerCellType.profile.rawValue {
            if UserManager.shared.isLoggedIn {
                self.performSelector(onMainThread: #selector(pushProfileScreen), with: nil, waitUntilDone: false)
            } else {
                self.performSelector(onMainThread: #selector(pushLoginScreen), with: nil, waitUntilDone: false)
            }
        } else {
            self.performSelector(onMainThread: #selector(handleHamburgerTap), with: items[indexPath.row], waitUntilDone: false)
        }
    }
}

private extension HamburgerMenuController {
    @objc func pushLoginScreen() {
        dismiss(animated: true) {
            UIViewController.rootViewController?.navigate(to: LoginController.self, of: .user, presentationType: .push, prepareForNavigation: nil)
        }
    }
    
    @objc func pushProfileScreen() {
        dismiss(animated: true) {
            UIViewController.rootViewController?.navigate(to: ProfileDetailViewController.self, of: .user, presentationType: .push, prepareForNavigation: nil)
        }
    }
    
    @objc func handleHamburgerTap(_ type: String) {
        switch type {
        case "Dashboard":
            dismiss(animated: true) { [weak self] in
                self?.switchToTab(.home)
            }
        case "Music":
            dismiss(animated: true) { [weak self] in
                self?.switchToTab(.music)
            }
        case "Originals":
            dismiss(animated: true) { [weak self] in
                self?.switchToTab(.originals)
            }
        case "Jatra":
            dismiss(animated: true) { [weak self] in
                self?.switchToTab(.jatra)
            }
        case "Movies":
            dismiss(animated: true) { [weak self] in
                self?.switchToTab(.movies)
            }
        case "My Profile":
            pushProfileScreen()
        case "Log Out":
            logOut()
        case "My Favorites":
            dismiss(animated: true) { [weak self] in
                self?.showFavoriteList()
            }
        default:
            break
        }
    }
    
    func logOut() {
        CustomLoader.addLoaderOn(self.view, gradient: false)
        UserManager.shared.logoutUser(handler: {[weak self] (success) in
            CustomLoader.removeLoaderFrom(self?.view)
            if success {
                self?.dismiss(animated: true, completion: nil)
            } else {
                self?.showAlertView("Error!", message: "Unexpected error occure.")
            }
        })
    }
    
    func showFavoriteList() {
        UIViewController.rootViewController?.navigate(to: VideoListController.self, of: .home, presentationType: .push, prepareForNavigation: nil)
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
