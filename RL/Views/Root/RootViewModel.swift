//
//  RootViewModel.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/12.
//

import SwiftUI
import Combine

class RootViewModel: ObservableObject {
    
    @Published var tabSelection: Int = 0
    
    @Published var tabNavigationHidden: Bool = false
    
    @Published var tabNavigationTitle: LocalizedStringKey = ""
    
    @Published var tabNavigationbarTrailingItems: AnyView = .init(EmptyView())
    
}

