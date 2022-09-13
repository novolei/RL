//
//  UserSessionManager.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/13.
//

import Appwrite
import Foundation

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    private let userDefaults = UserDefaults.standard
    
    @Published var checkedForUser = false
    @Published var user: User?
    
    init() {
        user = getCurrentUser()
    }
    
    private func getCurrentUser() -> User? {
        if user == nil {
            if let data = userDefaults.object(forKey: Constant.AUTH_USER_KEY) as! User? {
                user = data
                    
            } else {
                print("Nil user found")
                return nil
            }
        }
        return user
    }
    
    func setCurrentUser(_ user: User) async {
        do {
            let user = try await Constant.AP_SHARED.account.get()
           
            userDefaults.set(user, forKey: Constant.AUTH_USER_KEY)
            
        } catch {
            print("Unable to Decode Note (\(error.localizedDescription))")
            return
        }
    
        DispatchQueue.main.async {
            self.user = user
        }
    }
}
