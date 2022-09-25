//
//  UserSessionManager.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/13.
//

import Appwrite
import Foundation

public extension UserDefaults {
    static let shared = UserDefaults(suiteName: "group.com.RL.messages")!
}

class UserSessionManager: ObservableObject {
    static let shared = UserSessionManager()
    private let userDefaults = UserDefaults.standard
    private let userMessages = UserDefaults.shared
    
    @Published var user: User?
    @Published var session: Session?
    @Published var chat_user: ChatUser?
    @Published var userID: String?
    @Published var messages: [String]?


    init() {
//        user = getCurrentUser()
        userID = getCurrentUserID()
    }
    
   
    
    /// Description
    /// - Parameters:
    ///   - data: <#data description#>
    ///   - collectionID: <#collectionID description#>
    private func setMessages(data: [String], collectionID: String) {
        userMessages.set(data, forKey: collectionID)
        
    }
    
    public func getMessages(collectionID: String) -> [String]? {
        guard let data = userMessages.object(forKey: collectionID) else { return nil }//test
        messages = (data as! [String])//t
        
        return messages//
    }

    private func setSession(session: Session) {
        userDefaults.set(session.toMap(), forKey: Constant.SESSION_KEY)
    }
    
    public func getSession() -> Session? {
        guard let data = userDefaults.object(forKey: Constant.SESSION_KEY) else { return nil }
        session = Session.from(map: data as! [String: Any])
        return session
    }
    
    private func readPrivateKey() -> String? {
        guard let data = userDefaults.string(forKey: Constant.SESSION_KEY) else { return nil }
        return data
    }
    
    private func deleteSession()  {
        userDefaults.removeObject(forKey: Constant.SESSION_KEY)
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
    
     func getChatUser() -> ChatUser? {
        if chat_user == nil {
            if let data = userDefaults.object(forKey: Constant.CHAT_USER_KEY) as! ChatUser? {
                chat_user = data
                    
            } else {
                print("Nil chat user found")
                return nil
            }
        }
        return chat_user
    }
    
    func saveChatUser(user: ChatUser) {
        userDefaults.set(user, forKey: Constant.CHAT_USER_KEY)
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
