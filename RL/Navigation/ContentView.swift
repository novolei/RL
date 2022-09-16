//
//  ContentView.swift
//  Shared
//
//  Created by Meng To on 2021-06-16.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var userSessionManager = UserSessionManager.shared
    @StateObject var model = Model()
    
    var body: some View {
        Group {
            
            if userSessionManager.userID == Optional(""){
               
                LoginView()
//                RootView()
//                    .environmentObject(model)
                
            } else {
                RootView()
                    .environmentObject(model)
               
               
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
