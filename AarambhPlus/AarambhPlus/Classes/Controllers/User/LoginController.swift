//
//  LoginController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginController: UIViewController {

    @IBOutlet weak private var userNameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak private var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        userNameTextField.selectedLineColor = UIColor.appColor()
        userNameTextField.selectedTitleColor = UIColor.appColor()
        passwordTextField.selectedLineColor = UIColor.appColor()
        passwordTextField.selectedTitleColor = UIColor.appColor()
        
        loginButton.layer.borderWidth = 1
        loginButton.layer.borderColor = UIColor.appColor().cgColor
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
    
    func initialSetUp() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
        userNameTextField.selectedTitleColor = UIColor.appColor()
        passwordTextField.selectedTitleColor = UIColor.appColor()
        userNameTextField.selectedLineColor = UIColor.appColor()
        passwordTextField.selectedLineColor = UIColor.appColor()
    }
}
