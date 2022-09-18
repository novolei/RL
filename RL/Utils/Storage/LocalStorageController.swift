//
//  LocalStorageController.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/16.
//

import Appwrite
import Foundation
import SwiftUI

class LocalStorageController: ObservableObject {

    @Default(\.session) var session
    
    private let userDefaults = UserDefaults.standard
    
    func saveSession(session: Session) {
//        self.session = session
    }
    
    func deleteSession() {
        userDefaults.removeObject(forKey: Constant.SESSION_KEY)
    }
}
