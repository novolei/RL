//
//  AppWriteService.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/13.
//

import Appwrite
import Foundation
import NIO
import SwiftUI

class AppwriteService: ObservableObject {
    
    static let shared = AppwriteService()
    
    let client = Client()
        .setEndpoint("http://152.70.90.1:5525/v1")
        .setProject("newchat")
        .setSelfSigned(true)
    
    let database: Databases
    let account: Account
    let storage: Storage
    let avatars: Avatars
    let realtime: Realtime
    var databaseId = "default" // "NoSignal"
    var collectionId = "users"
    
    init() {
        database = Databases(client, databaseId)
        account = Account(client)
        storage = Storage(client)
        avatars = Avatars(client)
        realtime = Realtime(client)
        
    }
    
}



