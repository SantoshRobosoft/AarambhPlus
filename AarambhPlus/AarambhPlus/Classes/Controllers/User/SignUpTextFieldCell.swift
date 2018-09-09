//
//  SignUpTextFieldCell.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class SignUpTextFieldCell: UICollectionViewCell {
    @IBOutlet weak private var textField: SkyFloatingLabelTextField!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var indexPath: IndexPath!
    private var model: SignUpTextFieldModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textField.delegate = self
        textField.selectedLineColor = UIColor.appColor()
        textField.selectedTitleColor = UIColor.appColor()
    }
    
    func updateUI(info: SignUpTextFieldModel, at index: IndexPath) {
        self.indexPath = index
        self.model = info
        textField.placeholder = info.placeHolder
        textField.text = info.currentValue
        if let error = info.errorMessage {
            textField.errorMessage = ""//info.placeHolder
            textField.errorColor = UIColor.red
            errorLabel.text = error
        } else {
            errorLabel.text = nil
        }
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
    
    @IBOutlet weak private var signUpButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        signUpButton.layer.borderColor = UIColor.appColor().cgColor
        signUpButton.layer.borderWidth = 1
    }
    @IBAction func didTapSignUpButton(_ sender: UIButton) {
        sender.isEnabled = false
        signUpButtonClicked?(sender)
    }
}
