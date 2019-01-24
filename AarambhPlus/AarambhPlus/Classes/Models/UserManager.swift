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
        guard let user = user else {
            handler?(false)
            return
        }
        NetworkManager.signOut(user: user) {[weak self] (result) in
            if self?.parseError(result) != nil {
                UserDefaults.standard.removeObject(forKey: kSavedUserId)
                UserDefaults.standard.removeObject(forKey: kSavedUserEmail)
                UserDefaults.standard.synchronize()
                self?.user = nil
                handler?(true)
            } else {
                handler?(false)
            }
        }
    }
    
    func parseError<T>(_ result: DataResult<T>) -> APIResponse<T>? {
        switch result {
        case .success(let response):
            return response
        case .failure(_):
            return nil
        }
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
