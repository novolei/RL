//
//  DataStoreController.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/16.
//

import Appwrite
import Foundation
import SwiftUI

class DataStoreController: ObservableObject {
    let createMessageCollectionFunctionKey = "createMsg"
    let notifyUserFunctionKey = "notifyUser"
    @ObservedObject var userSessionManager = UserSessionManager.shared
    let database: Databases?
    let session: Session
    let function: Functions?
    let realtime: Realtime?
    @Published var allUsers: [ChatUser] = .init()
    
    init(session: Session) {
        self.session = session
        self.database = Constant.AP_SHARED.database
        self.function = Constant.AP_SHARED.function
        self.realtime = Constant.AP_SHARED.realtime
        
        subscribeToNotifications()
    }
    
    func getUser(userID: String, failureCompletion: @escaping (String) -> Void) async throws -> ChatUser? {
        do {
            let document = try await database?.getDocument(collectionId: Constant.AUTH_USER_KEY, documentId: userID)
            let chatuser = ChatUser.from(map: document?.toMap()["data"] as! [String: Any])
            
            return chatuser
        } catch {
            failureCompletion("getUser Failed:\n\(error.localizedDescription)")
            return nil
        }
    }
    
    func isPublicKeyAvailable(failureCompletion: @escaping (String) -> Void) async throws -> Bool {
        var result: Bool?
        do {
            let document = try await database?.getDocument(collectionId: Constant.AUTH_USER_KEY, documentId: session.userId)
            
            let chatuser = ChatUser.from(map: document?.toMap()["data"] as! [String: Any])
            
            if chatuser.public_key != "" {
                result = true
            } else {
                result = false
            }
        
        } catch {
            failureCompletion("PublicKey Available:\n\(error.localizedDescription)")
        }
        return result!
    }
    
    func updatePublicKey(pubKey: String, failureCompletion: @escaping (String) -> Void) async throws {
        do {
            let _ = try await database?.updateDocument(
                collectionId: Constant.AUTH_USER_KEY,
                documentId: session.userId,
                data: ["public_key": pubKey]
            )
        } catch {
            failureCompletion("update PublicKey Failure:\n\(error.localizedDescription)")
        }
    }
    
    func getAllUsers(failureCompletion: @escaping (String) -> Void) async throws -> DocumentList? {
        do {
            let documentsList = try await database?.listDocuments(collectionId: Constant.AUTH_USER_KEY,
                                                                  orderAttributes: ["name"],
                                                                  orderTypes: ["ASC"])
            let convert: ([String: Any]) -> ChatUser = { dict in
                ChatUser.from(map: dict)
            }
            
            DispatchQueue.main.async {
                self.allUsers = (documentsList?.convertTo(fromJson: convert))!
            }
            return documentsList
            
        } catch {
            failureCompletion("Get all users Failure:\n\(error.localizedDescription)")
            return nil
        }
    }
    
    func updateUserData(data: [String: Any], failureCompletion: @escaping (String) -> Void) async throws -> Document? {
        do {
            let result = try await database?.updateDocument(
                collectionId: Constant.AUTH_USER_KEY,
                documentId: session.userId,
                data: data
            )
            return result!
        } catch {
            failureCompletion("update UserData Failure:\n\(error.localizedDescription)")
            return nil
        }
    }
    
    func createMessageCollection(user1: String, user2: String, failureCompletion: @escaping (String) -> Void) async throws -> Execution? {
        do {
            let result = try await function?.createExecution(
                functionId: createMessageCollectionFunctionKey,
                data: "\(user1)-\(user2)",
                async: false
            )
            
            return result!
        } catch {
            failureCompletion("CreateMessageCollection Failure:\n\(error.localizedDescription)")
            // catchError(K.showErrorToast)
            return nil
        }
    }
    
    func getDataDoucument(collectionID: String, documentID: String, failureCompletion: @escaping (String) -> Void) async throws -> Document? {
        do {
            let result = try await database?.getDocument(
                collectionId: collectionID,
                documentId: documentID
            )
            
            return result!
        } catch {
            failureCompletion("CreateMessageCollection Failure:\n\(error.localizedDescription)")
            // catchError(K.showErrorToast)
            return nil
        }
    }
    
    func createDataDocument(collectionID: String, documentID: String, data: [String: Any], failureCompletion: @escaping (String) -> Void) async throws -> Document? {
        do {
            let result = try await database?
                .createDocument(
                    collectionId: collectionID,
                    documentId: documentID,
                    data: data
                )
            return result!
        } catch {
            failureCompletion("createDocument Failure:\n\(error.localizedDescription)")
            // catchError(K.showErrorToast)
            return nil
        }
    }
    
    func updateDataDocument(collectionID: String, documentID: String, data: [String: Any], failureCompletion: @escaping (String) -> Void) async throws -> Document? {
        do {
            let result = try await database?
                .updateDocument(
                    collectionId: collectionID,
                    documentId: documentID,
                    data: data
                )
            return result!
        } catch {
            failureCompletion("updateDocument Failure:\n\(error.localizedDescription)")
            // catchError(K.showErrorToast)
            return nil
        }
    }
    
    func notifyUser(user1: String, user2: String, failureCompletion: @escaping (String) -> Void) async throws {
        do {
            let _ = try await function?.createExecution(
                functionId: notifyUserFunctionKey,
                data: "\(user1)-\(user2)",
                async: false
            )
        } catch {
            failureCompletion("notifyUser Failure:\n\(error.localizedDescription)")
            // catchError(K.showErrorToast)
        }
    }
    
    func subscribeToNotifications() {
        _ = realtime?
            .subscribe(channels: ["databases.default.collections.notifications.documents.\(session.userId)"]) { _ in
            }
    }
    
    func subscribeToChat(collectionID: String, failureCompletion: @escaping (String) -> Void) -> RealtimeSubscription? {
        return realtime?
            .subscribe(channels: ["databases.default.collections.\(collectionID)"]) { _ in
            }
    }
    
    func logOut() async throws {
        do {
            _ = try await Constant.AP_SHARED.account.deleteSession(sessionId: session.id)
            userSessionManager.removeUser()
        }
        catch{
            print("errrrrrr")
        }
       
    }
    
    func updatePassword(oldPwd: String, newPwd: String, failureCompletion: @escaping (String) -> Void) async throws {
        do {
            let _ = try await Constant.AP_SHARED.account.updatePassword(password: newPwd, oldPassword: oldPwd)
        } catch {
            failureCompletion("notifyUser Failure:\n\(error.localizedDescription)")
            // catchError(K.showErrorToast)
        }
    }
}
