//
//  RootView.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/12.
//

import SwiftUI

struct RootView: View {
//    @ObservedObject var model = RootViewModel()
    @State private var selection: Int = 0
    @EnvironmentObject var imagePicker:ImagePicker
    
    private var itemType: ItemType {
        ItemType(rawValue: selection)!
    }
    
    @State private var currentTab: Tabes = .Home
    // Hiding Tab Bar...
    init() {
        UITabBar.appearance().isHidden = true
    }

    let homeView = MainEntry()
    let contactView = Text("Contacts")
    let discoverView = Text("Discover")
    let meView = Text("Me View")
    
    var tabTitle: String {
        switch currentTab {
        case .Home:
            return "Home"
        case .Liked:
            return "Linked"
//        case .Cart:
//            return "Cart"
        case .Profile:
            return "Profile"
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                //                KFImage(url)
                //                    .setProcessor(blackWhite ? BlackWhiteProcessor() : DefaultImageProcessor())
                //                    .onSuccess { r in
                //                        print("suc: \(r)")
                //                    }
                //                    .onFailure { e in
                //                        print("err: \(e)")
                //                    }
                //                    .placeholder { progress in
                //                        ProgressView(progress).frame(width: 100, height: 100)
                //                            .border(Color.green)
                //                    }
                //                    // Do not animate for the first image. Otherwise it causes an unwanted animation when the page is shown.
                //                    .forceTransition(forceTransition)
                //                    .resizable()
               
                if let image = imagePicker.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        .ignoresSafeArea()
//                        .opacity(0.63)
                        .blur(radius: 3)
                }
                else{
                    Image("Background 3")
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
                        //                .scaledToFit()
                        .ignoresSafeArea()
                        .opacity(0.63)
                        .blur(radius: 50)
                }
            }
          
            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            NavigationView {
                VStack(alignment: .leading, spacing: 0) {
                    TabView(selection: $currentTab) {
                        homeView
//                            .tabItem {
//                                Item(type: .chat, selection: selection)
//                            }
//                            .tag(ItemType.chat.rawValue)
                            .tag(Tabes.Home)
                        
                        contactView
//                            .tabItem {
//                                Item(type: .contact, selection: selection)
//                            }
//                            .tag(ItemType.contact.rawValue)
                            .tag(Tabes.Home)
                        
                        discoverView
//                            .tabItem {
//                                Item(type: .discover, selection: selection)
//                            }
                            .tag(Tabes.Liked)
                        
                        meView
//                            .tabItem {
//                                Item(type: .me, selection: selection)
//                            }
                            .tag(Tabes.Profile)
                    }
                    .navigationBarBackButtonHidden(true)
                    .navigationBarHidden(itemType.isNavigationBarHidden(selection: selection))
//                    .navigationBarTitle(itemType.title, displayMode: .inline)
                    
                    .navigationBarItems(trailing: itemType.navigationBarTrailingItems(selection: selection))
                    
                    .safeAreaInset(edge: .bottom, spacing: 0) {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(spacing: 0) {
                                ForEach(Tabes.allCases, id: \.self) { tab in

                                    Button {
                                        // updating tab...
                                        currentTab = tab
                                        print("select index is \(tabTitle)")
                                    } label: {
                                        Image(tab.rawValue)
                                            .resizable()
                                            .renderingMode(.template)
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 22, height: 22)
                                            // Applying little shadow at bg...
                                            .background(
                                                Color("Purple")
                                                    .opacity(0.15)
                                                    .cornerRadius(5)
                                                    // blurring...
                                                    .blur(radius: 5)
                                                    // Making little big...
                                                    .padding(-7)
                                                    .opacity(currentTab == tab ? 1 : 0)
                                            )
                                            .frame(maxWidth: .infinity)
                                            .foregroundColor(currentTab == tab ? Color.green.opacity(0.64) : Color.black.opacity(0.3))
                                    }
                                    .padding(.top, 15)
                                }
                            }
                            
//
                        }
                        .frame(maxWidth: .infinity, maxHeight: 60)
                        .background(.clear)
                        //                    .padding(.bottom, 10)
                    }
                }
            }
            .navigationBarTitle(tabTitle, displayMode: .inline)
        }
    }
}

struct Item: View {
    let type: ItemType
    
    let selection: Int
    
    var body: some View {
        VStack {
            if type.rawValue == selection {
                type.selectedImage
            } else {
                type.image
            }
            
            Text(type.title)
        }
    }
}

enum ItemType: Int {
    case chat
    case contact
    case discover
    case me
    
    var image: Image {
        switch self {
        case .chat:
            return Image("root_tab_chat")
        case .contact:
            return Image("root_tab_contact")
        case .discover:
            return Image("root_tab_discover")
        case .me:
            return Image("root_tab_me")
        }
    }
    
    var selectedImage: Image {
        switch self {
        case .chat:
            return Image("root_tab_chat_selected")
        case .contact:
            return Image("root_tab_contact_selected")
        case .discover:
            return Image("root_tab_discover_selected")
        case .me:
            return Image("root_tab_me_selected")
        }
    }
    
    var title: String {
        switch self {
        case .chat:
            return "WeChat"
        case .contact:
            return "Contacts"
        case .discover:
            return "Discvoer"
        case .me:
            return "Me"
        }
    }
    
    func isNavigationBarHidden(selection: Int) -> Bool {
        selection == ItemType.chat.rawValue
    }
    
    func navigationBarTrailingItems(selection: Int) -> AnyView {
        switch ItemType(rawValue: selection)! {
        case .chat:
            return AnyView(Image(systemName: "plus.circle"))
        case .contact:
            return AnyView(Image(systemName: "person.badge.plus"))
        case .discover:
            return AnyView(EmptyView())
        case .me:
            return AnyView(EmptyView())
        }
    }
}

struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
    }
}

// Making Case Iteratable...
// Tab Cases...
enum Tabes: String, CaseIterable {
    // Raw Value must be image Name in asset..
    case Home
    case Liked

//    case Cart
    case Profile
}
