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
    static let shared = AuthViewModel()
    
    var userId = ""
    private var tempCurrentUser: User?
    
    // Log Status...
    @AppStorage("log_Status") var log_Status: Bool = false
    @AppStorage("userID") var userID: String = ""
    
    
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
            
            tempCurrentUser = user
            await login(email: email, password: password) { errorMsg in
                self.errorMsg = errorMsg
            }
            
            let user_document = try await Constant.AP_SHARED.database.createDocument(
                collectionId: "users",
                documentId: userId,
                data: ["name": name, "id": userId, "email": email, "bio": "techTalk", "fullname": "ryan Liu"]
            )
            print(String(describing: user_document))
            
        } catch {
            failureCompletion("Sign up  Failed!")
        }
//        isShowingDialog = true
    }
    
    public func login(email: String, password: String, failureCompletion: @escaping (String) -> Void) async {
        
        do {
            let session = try await Constant.AP_SHARED.account.createEmailSession(email: email, password: password)
            print("DEBUG: session uid \(String(describing: session.userId))")
            withAnimation {
                userID = session.userId
            }
//            try await getAccount()
        } catch {
            failureCompletion("Login  Failed!")
        }
    }
}
