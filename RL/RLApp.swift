//
//  RLApp.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/5.
//

import SwiftUI

@main
struct RLApp: App {
    @StateObject var model = Model()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(model)
        }
    }
}
