//
//  ProfileDetailViewController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/12/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class ProfileDetailViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    class func controller() -> ProfileDetailViewController {
        return UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "\(ProfileDetailViewController.self)") as! ProfileDetailViewController
    }
    
    @IBAction func didTapLogOutButton(_ sender: UIButton) {
        guard let user = UserManager.shared.user else {
            showAlert(title: "Error!!", message: "Unexpected error occure.")
            return
        }
        CustomLoader.addLoaderOn(view, gradient: true)
        NetworkManager.signOut(user: user) {[weak self] (result) in
            CustomLoader.removeLoaderFrom(self?.view)
            if self?.parseError(result) != nil {
                UserManager.shared.logoutUser(handler: { (success) in
                    if success {
                        self?.navigationController?.popViewController(animated: true)
                    } else {
                        self?.showAlert(title: "Error!!", message: "Unexpected error occure.")
                    }
                })
                
            }
        }
    }
    
}

extension ProfileDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileDetailCell", for: indexPath) as! ProfileDetailCell
        cell.configureCell()
        return cell
    }
}
