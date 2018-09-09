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
        self.saveUserToLocalStorage(user: user)
    }
    
    func getUserFromLocalStorage() {
        if let data = UserDefaults.standard.object(forKey: kSavedUser) as? Data, let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            self.user = user
        }
    }
}

private extension UserManager {
    func saveUserToLocalStorage(user: User) {
        let obj = NSKeyedArchiver.archivedData(withRootObject: user)
        UserDefaults.standard.set(obj, forKey: kSavedUser)
    }
}
