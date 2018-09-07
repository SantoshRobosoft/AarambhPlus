//
//  SignUpController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var items = ["Name","Email","Mobile", "Password", "Confirm Password"]
    private var fields = [SignUpTextFieldModel]()
    
    class func controller() -> SignUpController {
        return UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        createFieldsInSignUpScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow),
                                               name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide),
                                               name: .UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let bottomInset = keyboardSize.height
            bottomConstraint.constant = bottomInset
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        bottomConstraint.constant =  0.0
    }

}

extension SignUpController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fields.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == fields.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignUpButtonCell", for: indexPath) as! SignUpButtonCell
            cell.signUpButtonClicked = { [weak self] sender in
                self?.signUpButtonTapped()
                sender.isEnabled = true
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SignUpTextFieldCell", for: indexPath) as! SignUpTextFieldCell
            cell.updateUI(info: fields[indexPath.row], at: indexPath)
            return cell
        }
    }
}
extension SignUpController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: windowWidth, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 50, left: 0, bottom: 10, right: 0)
    }
}
private extension SignUpController {
    func createFieldsInSignUpScreen() {
        for item in items {
            let field = SignUpTextFieldModel(placeHolder: item, currentValue: nil)
            fields.append(field)
        }
        collectionView.reloadData()
    }
    
    func signUpButtonTapped() {
        // validate the data and hit the api
        collectionView.endEditing(true)
        var noError = true
        for file in fields {
            if !file.validate(){
                noError = false
            }
        }
        if !noError {
            collectionView.reloadData()
            return
        }
        if let controllers = navigationController?.viewControllers{
            for controller in controllers {
                if !(controller.isKind(of: LoginController.self) || controller.isKind(of: LoginController.self)) {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
    }
}
