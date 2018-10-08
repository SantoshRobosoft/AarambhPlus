//
//  SignUpTextFieldModel.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class SignUpTextFieldModel: NSObject {
    
    var placeHolder: String?
    var oldValue: String?
    var currentValue: String?
    var errorMessage: String?
    var isSecureText = false
    
    init(placeHolder: String?, currentValue: String?) {
        self.placeHolder = placeHolder
        self.oldValue = currentValue
        self.currentValue = currentValue
    }
    
    func validate() -> Bool {
        if currentValue == nil || currentValue?.isEmpty == true {
            errorMessage = "Please enter \(placeHolder ?? "")"
            return false
        } else {
            if placeHolder?.lowercased() == "email", currentValue?.isValidEmail() == false {
                errorMessage = "please enter a valid email id"
                return false
            }
            errorMessage = nil
        }
        return true
    }
    
    func getServerKey() -> String? {
        if placeHolder?.lowercased().contains("confirm password") == true {
            return nil
        }
        return placeHolder?.lowercased()
    }
}
