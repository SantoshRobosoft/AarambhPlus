//
//  LoginController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class LoginController: UIViewController {

    @IBOutlet weak private var userNameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
    }
    
    class func controller() -> LoginController {
        return UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
    }

    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpController.controller(), animated: true)
    }
    
    @IBAction func didTapForgorPasswordButton(_ sender: UIButton) {
    }
    
    @IBAction func didTapLogInButton(_ sender: UIButton) {
    }
    
}

extension LoginController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
