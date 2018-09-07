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
            errorMessage = nil
        }
        return true
    }
}
