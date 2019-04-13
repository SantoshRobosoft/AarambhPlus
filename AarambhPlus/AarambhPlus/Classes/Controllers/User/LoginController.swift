//
//  LoginController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class LoginController: BaseViewController {

    @IBOutlet weak private var userNameTextField: UITextField!
    @IBOutlet weak private var passwordTextField: UITextField!
    @IBOutlet weak private var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
//        userNameTextField.selectedLineColor = UIColor.appColor()
//        userNameTextField.selectedTitleColor = UIColor.appColor()
//        passwordTextField.selectedLineColor = UIColor.appColor()
//        passwordTextField.selectedTitleColor = UIColor.appColor()
        addGradient()
//        loginButton.layer.borderWidth = 1
//        loginButton.layer.borderColor = UIColor.appColor().cgColor
    }
        
    class func controller() -> LoginController {
        return UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "LoginController") as! LoginController
    }

    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        navigationController?.pushViewController(SignUpController.controller(), animated: true)
    }
    
    @IBAction func didTapForgorPasswordButton(_ sender: UIButton) {
        UIViewController.rootViewController?.navigate(to: ForgotPasswordViewController.self, of: .user, presentationType: .push, prepareForNavigation: nil)
    }
    
    @IBAction func didTapLogInButton(_ sender: UIButton) {
        guard let email = userNameTextField.text, !email.isEmpty else  {
            showAlert(title: "Error!", message: "Please enter email.")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(title: "Error!", message: "Please enter password.")
            return
        }
        CustomLoader.addLoaderOn(view, gradient: false)
        NetworkManager.loginWith(email: email, password: password) {[weak self] (result) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let response = self?.parseError(result) {
                UserManager.shared.updateUser(response.data)
                self?.navigationController?.popViewController(animated: true)
            }
        }
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
//        userNameTextField.selectedTitleColor = UIColor.appColor()
//        passwordTextField.selectedTitleColor = UIColor.appColor()
//        userNameTextField.selectedLineColor = UIColor.appColor()
//        passwordTextField.selectedLineColor = UIColor.appColor()
    }
}
