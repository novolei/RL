//
//  UsersListController.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/17.
//

import Foundation
import SwiftUI

class UsersListController: ObservableObject {
    @Published var allUsers: [ChatUser]?
    let userSession = UserSessionManager.shared
    let databaseController: DataStoreController?
    var currentUserID: String
    
    init(currentUserID: String) {
        self.databaseController = DataStoreController(session: self.userSession.getSession()!)
        self.currentUserID = currentUserID
    }
    
    func setUserID(userID: String) {
        self.currentUserID = userID
    }
    
    func getUsers() async throws {
        self.allUsers = nil
        
        let documentsList = try await databaseController?.getAllUsers(failureCompletion: { err in
            print("get all users Failed \(err)")
        })
        
        let convert: ([String: Any]) -> ChatUser = { dict in
            ChatUser.from(map: dict)
        }
        
        DispatchQueue.main.async {
            self.allUsers = (documentsList?.convertTo(fromJson: convert))!
        }
    }
}
