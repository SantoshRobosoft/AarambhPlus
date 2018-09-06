//
//  HamburgerMenuController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/6/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class HamburgerMenuController: UIViewController {

    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    class func controller() -> HamburgerMenuController {
        return UIStoryboard(name: "HamburgerMenu", bundle: nil).instantiateViewController(withIdentifier: "\(HamburgerMenuController.self)") as! HamburgerMenuController
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
        if indexPath.row == 0 {
            return tableView.dequeueReusableCell(withIdentifier: "HamburgerProfileCell", for: indexPath)
        } else {
            return tableView.dequeueReusableCell(withIdentifier: "HamburgerItemCell", for: indexPath)
        }
    }
}

extension HamburgerMenuController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension HamburgerMenuController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SidePanelCustomTransitionAnimator()
        animator.duration = 0.4
//        animator.direction = .left
        return animator
    }
    
    func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = SidePanelCustomTransitionAnimator()
        animator.duration = 0.4
//        animator.direction = .right
        return animator
    }
    
}
