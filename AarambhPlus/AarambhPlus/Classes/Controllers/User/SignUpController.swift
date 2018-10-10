//
//  SignUpController.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

enum SignUpFieldType: String {
    case name = "Name"
    case email = "Email"
    case mobile = "Mobile"
    case password = "Password"
    case confirmPassword = "Confirm Password"
    
    func getModel() -> SignUpTextFieldModel {
        switch self {
        case .name, .email, .mobile:
            return SignUpTextFieldModel(placeHolder: rawValue, currentValue: nil)
        case .password, .confirmPassword:
            let model = SignUpTextFieldModel(placeHolder: rawValue, currentValue: nil)
            model.isSecureText = true
            return model
        }
    }
    static var cases: [SignUpFieldType] {
        return [.name, .email, .mobile, .password, .confirmPassword]
    }
}

class SignUpController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    private var fields = [SignUpTextFieldModel]()
    
    class func controller() -> SignUpController {
        return UIStoryboard(name: "User", bundle: nil).instantiateViewController(withIdentifier: "SignUpController") as! SignUpController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign Up"
        createFieldsInSignUpScreen()
        addGradient()
//        addGradientToCollectionView()
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
        return 6//SignUpFieldType.allCases.count + 1
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
        return CGSize(width: windowWidth, height: 70)
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
        for item in SignUpFieldType.cases {
            fields.append(item.getModel())
        }
        collectionView.reloadData()
    }
    
    func signUpButtonTapped() {
        // validate the data and hit the api
        collectionView.endEditing(true)
        var noError = true
        var params = [String:Any]()
        for file in fields {
            if let serverKey = file.getServerKey() {
                params[serverKey] = file.currentValue
            }
            if !file.validate(){
                noError = false
            }
        }
        if fields[3].currentValue != fields[4].currentValue {
            fields[4].errorMessage = "Password mismatch."
            noError = false
        }
        if !noError {
            collectionView.reloadData()
            return
        }
        params["authToken"] = kAuthToken
        CustomLoader.addLoaderOn(view, gradient: false)
        NetworkManager.registerUser(param: params) {[weak self] (result) in
            CustomLoader.removeLoaderFrom(self?.view)
            if let response = self?.parseError(result) {
                UserManager.shared.updateUser(response.data)
                self?.popToRootViewController()
            }
        }
        
    }
    
    func popToRootViewController() {
        if let controllers = navigationController?.viewControllers {
            for controller in controllers {
                if !(controller.isKind(of: LoginController.self) || controller.isKind(of: LoginController.self)) {
                    navigationController?.popToViewController(controller, animated: true)
                }
            }
        }
    }
    
    func addGradientToCollectionView() {
        let colorTop = UIColor.colorRGB(255, g: 200, b: 55).cgColor
        let colorBottom = UIColor.colorRGB(255, g: 128, b: 8).cgColor
        let gradient = CAGradientLayer()
        gradient.colors = [colorTop, colorBottom]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = view.frame
        self.collectionView.layer.insertSublayer(gradient, at: 0)
    }
}

class Box<T> {
    typealias Listner = (T) -> Void
    var listner: Listner?
    var value: T {
        didSet {
            listner?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listner: Listner?) {
        self.listner = listner
        listner?(value)
    }
}
