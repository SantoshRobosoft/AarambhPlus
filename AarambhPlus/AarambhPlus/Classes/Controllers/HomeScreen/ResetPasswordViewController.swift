//
//  ResetPasswordViewController.swift
//  AarambhPlus
//
//  Created by BIRAJA PRASAD NATH on 08/04/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ResetPasswordViewController: BaseViewController {
    @IBOutlet weak private var newPasswordTextField: UITextField!
    @IBOutlet weak private var confirmPasswordTextField: UITextField!
    @IBOutlet weak private var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Reset Password"
        //addGradient()
    }
    
    func autoAlert() {
        let alert = UIAlertController(title: "", message: "Password changed successfully.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 2
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        guard let newpassword = newPasswordTextField.text, !newpassword.isEmpty else  {
            showAlert(title: "Error!", message: "Please Enter New Password.")
            return
        }
        guard let confirmPassword = confirmPasswordTextField.text, !confirmPassword.isEmpty else {
            showAlert(title: "Error!", message: "Please Enter confirm password.")
            return
        }
        if newPasswordTextField.text != confirmPasswordTextField.text {
            let alertController = UIAlertController(title: "Error", message: "Password mismatch.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            self.present(alertController, animated: true, completion: nil)
        }
        else{
            CustomLoader.addLoaderOn(view, gradient: false)
            NetworkManager.resetpassword(password: newpassword) {[weak self] (result) in
                CustomLoader.removeLoaderFrom(self?.view)
                if (self?.parseError(result)) != nil {
                    self?.autoAlert()
                    self?.newPasswordTextField.text = ""
                }
            }
        }
    }

}
