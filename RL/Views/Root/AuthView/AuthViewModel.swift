//
//  AuthViewModel.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/13.
//

import Appwrite
import Foundation
import SwiftUI

class AuthViewModel: ObservableObject {
    @ObservedObject var userSessionManager = UserSessionManager.shared
//    private let userDefaults = UserDefaults.standard
    static let shared = AuthViewModel()
//    @Published var back_image:
    var userId = ""
    private var tempCurrentUser: User?
    @Published var suc_Msg: String = ""
    // Log Status...
    @AppStorage("log_Status") var log_Status: Bool = false
    @AppStorage("userID") var userID: String = ""
    @Published var didAuthUser: Bool = false
    @Published var didLogin: Bool = false
    @Published var sessionID: String = ""
    
    @Published var errorMsg: String? = ""
    
    
    public func create(name: String, email: String, password: String, failureCompletion: @escaping (String) -> Void) async throws {
        do {
            print("start sign up")
            let user = try await Constant.AP_SHARED.account.create(
                userId: "unique()",
                email: email,
                password: password,
                name: name
            )
            
            userId = user.id
                
            print("done sign up!")
            self.suc_Msg = "Register Successfully!"
            self.didAuthUser = true
            tempCurrentUser = user
//            await login(email: email, password: password) { errorMsg in
//                self.errorMsg = errorMsg
//            }
            
//            let user_document = try await Constant.AP_SHARED.database.createDocument(
//                collectionId: "users",
//                documentId: userId,
//                data: ["name": name, "id": userId, "email": email, "bio": "techTalk", "fullname": "ryan Liu"]
//            )
//            print(String(describing: user_document))
            
        } catch {
            failureCompletion("Sign up Failed!\n\(error.localizedDescription)")
        }
//        isShowingDialog = true
    }
    
    public func login(email: String, password: String, failureCompletion: @escaping (String) -> Void) async {
        
        do {
            let session = try await Constant.AP_SHARED.account.createEmailSession(email: email, password: password)
//            try await getAccount()
            self.didLogin = true
            self.sessionID = session.id
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
                withAnimation {
                    //userID = session.userId
                    self.userSessionManager.setCurrentUserID(session.userId )
                }
            }
//            try await getAccount()
        } catch {
            self.didLogin = false
            failureCompletion("Login  Failed!\n\(error.localizedDescription)")
        }
    }
    
    public func signout() async throws {
        do {
            
//            _ = try await Constant.AP_SHARED.account.deleteSessions()
            _ = try await Constant.AP_SHARED.account.deleteSession(sessionId: sessionID)
            userSessionManager.removeUser()
            self.didLogin = false
            self.didAuthUser = false
        } catch {
            //userSessionManager.removeUser()
            print("DEBUG:\(self.userSessionManager.userID! )")
        }
    }
    
    public func uploadProfileImage() {
        
    }
}
