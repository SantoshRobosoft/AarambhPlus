//
//  SignUpTextFieldCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class SignUpTextFieldCell: UICollectionViewCell {
    @IBOutlet weak private var textField: UITextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var indexPath: IndexPath!
    private var model: SignUpTextFieldModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
    }
    
    func updateUI(info: SignUpTextFieldModel, at index: IndexPath) {
        self.indexPath = index
        self.model = info
        textField.placeholder = info.placeHolder
        textField.text = info.currentValue
        errorLabel.text = info.errorMessage
    }
    
}

extension SignUpTextFieldCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text {
            let text = (currentText as NSString).replacingCharacters(in: range, with: string)
            model?.currentValue = text
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

class SignUpButtonCell: UICollectionViewCell {
    var signUpButtonClicked: ((_ sender: UIButton) -> Void)?
    
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        sender.isEnabled = false
        signUpButtonClicked?(sender)
    }
}
