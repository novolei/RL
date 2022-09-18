//
//  UserController.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/17.
//

import Appwrite
import Foundation
import SwiftUI

class UserController: ObservableObject {
    let currentSession: Session
    @Published var userData: ChatUser?
    @Published var onGoingChats: [ChatTile] = .init()
    let userSessionManager: UserSessionManager = .shared
    @ObservedObject var databaseController: DataStoreController
    @ObservedObject var usersListController: UsersListController
    var isInitialized = false
    var keyFound = false

    init(currentSession: Session) {
        self.currentSession = currentSession
        databaseController = .init(session: currentSession)
        usersListController = .init(currentUserID: currentSession.userId)
        usersListController.setUserID(userID: currentSession.userId)
        Task {
            try await usersListController.getUsers()
        }
        let user = userSessionManager.getChatUser()

        if user != nil {
            if !isInitialized {
                userData = user
                isInitialized = true
            }
        }

        Task {
            let remoteData = try await databaseController.getUser(userID: currentSession.userId, failureCompletion: { err in
                print("remote data err \(err)")
            })

            if remoteData != nil {
                if isInitialized {
                    userData = remoteData
                }
                userSessionManager.saveChatUser(user: userData!)
            }
        }

        onGoingChats = []
        if usersListController.allUsers?.count != 0, userData?.chat_ids.count != 0 {
            usersListController.allUsers?.forEach { chatuser in
                if (userData?.chat_ids.contains(chatuser.id)) != nil {
                    onGoingChats.append(ChatTile(chatUser: chatuser, messageStatus: MessageStatus.read))
                }
            }
        }
    }

    func chatStatusRead(userID: String) {
        onGoingChats.first(where: { $0.chatUser.id == userID })?.messageStatus
            = MessageStatus.read
    }

    func updateChatsStatus(notifications: [String]) {
        var ids = [String]()

        notifications.forEach { item in
            ids.append(item)
        }
        for item in onGoingChats {
            if ids.contains(item.chatUser.id) {
                ids.remove(item.chatUser.id)
                item.messageStatus = MessageStatus.unRead
            }
        }

        for newID in ids {
            let user = usersListController.allUsers?.first(where: { $0.id == newID })
            if user != nil {
                onGoingChats.append(ChatTile(chatUser: user!, messageStatus: MessageStatus.newUser))
            }
        }
    }

    func addChatID(newID: String, update: Bool = false) async throws -> Bool {
        var document: Document?
        var newIDs: [String]? = userData?.chat_ids

        newIDs = newIDs ?? []
        newIDs?.append(newID)
        Task {
            document = try await databaseController.updateUserData(data: ["chat_ids": newIDs!], failureCompletion: { err in
                print("update user data fail!\(err)")
            })
            DispatchQueue.main.async { [self] in
                self.userData?.chat_ids = userData?.chat_ids ?? []
                self.userData?.chat_ids.append(newID)
            }
        }

        let user = usersListController.allUsers?.first(where: { $0.id == newID })

        if user != nil {
            if update {
                onGoingChats[onGoingChats.firstIndex(where: { $0.chatUser.id == user!.id })!]
                    .messageStatus = MessageStatus.read
            } else {
                onGoingChats.append(
                    ChatTile(chatUser: user!, messageStatus: MessageStatus.read)
                )
            }
        }
        return document == nil ? false : true
    }
    
    func updateUserFromRemote() async throws {
        let remoteData = try  await databaseController.getUser(userID: currentSession.userId) { err in
            print("updateUserFromRemote \(err)")
            
        }
        
        if remoteData != nil {
            userData = remoteData
            userSessionManager.saveChatUser(user: userData!)
        }
    }
    
    func logOut() async throws{
        try await databaseController.logOut()
    }
}

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = firstIndex(of: object) {
            remove(at: index)
        }
    }
}
