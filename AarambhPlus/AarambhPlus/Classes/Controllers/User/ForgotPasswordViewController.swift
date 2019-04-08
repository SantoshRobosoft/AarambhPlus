//
//  ForgotPasswordViewController.swift
//  AarambhPlus
//
//  Created by BIRAJA PRASAD NATH on 08/04/19.
//  Copyright © 2019 Santosh Dev. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class ForgotPasswordViewController: BaseViewController {
    @IBOutlet weak private var userEmailTextField: UITextField!
    @IBOutlet weak private var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Forgot Password"
          //addGradient()
    }
    
    func autoAlert() {
        let alert = UIAlertController(title: "", message: "Please check your email to reset your password.", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        // change to desired number of seconds (in this case 5 seconds)
        let when = DispatchTime.now() + 3
        DispatchQueue.main.asyncAfter(deadline: when){
            // your code with delay
            alert.dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func didTapSubmitButton(_ sender: UIButton) {
        guard let email = userEmailTextField.text, !email.isEmpty else  {
            showAlert(title: "Error!", message: "Please enter email.")
            return
        }
        CustomLoader.addLoaderOn(view, gradient: false)
        NetworkManager.forgotPassword(email: email) {[weak self] (result) in
            CustomLoader.removeLoaderFrom(self?.view)
            if (self?.parseError(result)) != nil {
                self?.autoAlert()
                self?.userEmailTextField.text = ""
            }
        }
    }

}
