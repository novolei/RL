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
    @Published var userID: String?
    
    init() {
//        user = getCurrentUser()
        userID = getCurrentUserID()
       
    }
    
    private func getCurrentUserID() -> String {
        if userID == nil {
            if let data = userDefaults.string(forKey: Constant.AUTH_USERID_KEY) {
                userID = data
               
            } else {
                print("Nil userID found")
                return ""
            }
        } else {
            print(userID!)
        }
        
        return userID!
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
    
    func setCurrentUserID(_ userID: String) {
        userDefaults.set(userID, forKey: Constant.AUTH_USERID_KEY)

        DispatchQueue.main.async {
            self.userID = userID
        }
    }

    func removeUser() {
        DispatchQueue.main.async {
            self.userID = ""
        }
        userDefaults.removeObject(forKey: Constant.AUTH_USERID_KEY)
    }
    
    func setCurrentUser() async {
        do {
            let user = try await Constant.AP_SHARED.account.get()
           
            userDefaults.set(user, forKey: Constant.AUTH_USER_KEY)
            DispatchQueue.main.async {
                self.user = user
            }
            
        } catch {
            print("Unable to Decode Note (\(error.localizedDescription))")
            return
        }
    
//        DispatchQueue.main.async {
//            self.user = user
//        }
    }
}
