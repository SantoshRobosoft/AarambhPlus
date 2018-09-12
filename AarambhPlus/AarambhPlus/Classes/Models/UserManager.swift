//
//  UserManager.swift
//  AarambhPlus
//
//  Created by Santosh Kumar Sahoo on 9/7/18.
//  Copyright © 2018 Santosh Dev. All rights reserved.
//

import UIKit

class UserManager: NSObject {
    static let shared = UserManager()
    var user: User?
    var isLoggedIn: Bool {
        if let _ = user {
            return true
        }
        return false
    }
    
    func updateUser(_ user: User?) {
        guard let user = user else {
            return
        }
        self.user = user
        self.saveUserToLocalStorage(userId: user.id, email: user.email)
    }
    
    func getUserFromLocalStorage() {
        
    }
    
    func logoutUser(handler: ((_ success: Bool)->Void)?) {
        UserDefaults.standard.removeObject(forKey: kSavedUserId)
        UserDefaults.standard.removeObject(forKey: kSavedUserEmail)
        UserDefaults.standard.synchronize()
        self.user = nil
        handler?(true)
    }
}

private extension UserManager {
    func saveUserToLocalStorage(userId: String?, email: String?) {
        guard let userId = userId else {
            return
        }
        UserDefaults.standard.set(userId, forKey: kSavedUserId)
        UserDefaults.standard.set(email, forKey: kSavedUserEmail)
        UserDefaults.standard.synchronize()
    }
}
