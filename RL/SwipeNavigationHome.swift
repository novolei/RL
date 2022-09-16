//
//  SwipeNavigationHome.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/6.
//

//
//  SwipeNavigation.swift
//  uiPlayground
//
//  Created by Ryan Remaly on 2/13/21.
//

enum currentView {
    case center
    case left
    case right
}

let screenSize = UIScreen.main.bounds
let screenWidth = screenSize.width
let screenHeight = screenSize.height

import Kingfisher
import SwiftUI

struct SwipeNavigationHome: View {
    @State var activeView = currentView.center
    @State var viewState = CGSize.zero
    
    @State var appear = false
    @State var appearBackground = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: Model
    @State var showTopBar = true
    var url: URL {
        URL(string: "https://www.shutterstock.com/zh-Hant/blog/wp-content/uploads/sites/11/2020/10/1030-cover.png?w=1250&h=960&crop=1")!
    }

    private var blackWhite = false
    private var forceTransition = true
    
    var body: some View {
        ZStack(alignment: .top) {
            KFImage(url)
//                    .setProcessor(blackWhite ? BlackWhiteProcessor() : DefaultImageProcessor())
                .onSuccess { r in
                    print("suc: \(r)")
                }
                .onFailure { e in
                    print("err: \(e)")
                }
                .placeholder { progress in
                    ProgressView(progress).frame(width: 100, height: 100)
                        .border(Color.green)
                }
                // Do not animate for the first image. Otherwise it causes an unwanted animation when the page is shown.
                .forceTransition(forceTransition)
                .resizable()
                .scaledToFill()
//                    .aspectRatio(contentMode: .fit)
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                    
                .ignoresSafeArea()
                    
                .opacity(appear ? 0.63 : 0.7)
                .blur(radius: 5)

            VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                .ignoresSafeArea()
            if showTopBar {
                ZStack {
                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .contentShape(Rectangle())
                        }

                        Spacer()
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "gear")
                                .font(.title3)
                                .foregroundColor(.white)
                                .frame(width: 40, height: 40)
                                .contentShape(Rectangle())
                        }
                    }
                    .padding(.top, 5)
                    Text("chatUser.name")
                        .font(.custom(customFont, size: 16))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                }
                .padding(.top, 40)
                .padding(.horizontal, 5)
            }

            //            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
            //                            .edgesIgnoringSafeArea(.all)
            CenterView(activeView: .center)
                .padding(.top, 45)
                .scaleEffect(activeView == .center && viewState.width == .zero ? 1 : 0.85)
                //                .opacity(activeView == .center ? (viewState.width == .zero ? 1 : (0.5 - abs(viewState.width/screenWidth))) : 0)
                .opacity(activeView == .center && viewState.width == .zero ? 1 : 0)
                .blur(radius: activeView == .center ? (viewState.width == .zero ? 0 : 3) : 0)
                //                .animation(.easeInOut(duration: 0.5))
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.3))
                
            LeftView(activeView: activeView)
                .padding(.top, 45)
                .offset(x: self.activeView == currentView.left ? 0 : -screenWidth)
                .offset(x: activeView != .right ? viewState.width : 0)
                //                .animation(.easeInOut(duration: 0.5))
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.4))
                .opacity(appear ? 1 : 0)
            RightView(activeView: self.activeView)
                .padding(.top, 55)
                .offset(x: self.activeView == currentView.right ? 0 : screenWidth)
                .offset(x: activeView != .left ? viewState.width : 0)
                //                .animation(.easeInOut(duration: 0.5))
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.2))
        }
        .ignoresSafeArea()
//            .offset(y: appear ? 0 : proxy.size.height)
            
        .navigationTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden()
        .gesture(
            (self.activeView == currentView.center) ?
                    
                DragGesture(minimumDistance: 30, coordinateSpace: .global)
                .onChanged { value in
                        
                    self.viewState = value.translation
                }
                .onEnded { value in
                    if value.predictedEndTranslation.width > screenWidth / 2.8, value.startLocation.x < screenWidth / 4 {
//                            self.activeView = currentView.left
//                            dismissModal()
//                            simpleSuccess()
                        self.viewState = .zero
                        
                        print("left trans")
                        simpleSuccess()
                        presentationMode.wrappedValue.dismiss()
                    }
                    // && value.startLocation.x < screenWidth-120 && value.startLocation.x > screenWidth/4*3
                    else if value.predictedEndTranslation.width < -screenWidth / 3.8 {
                        self.activeView = currentView.right
                        simpleSuccess()
                        self.viewState = .zero
                        withAnimation(.spring(dampingFraction: 0.7)){
                            self.showTopBar = false
                        }
                        
                    }
                        
                    else {
                        self.viewState = .zero
                    }
                }
                : DragGesture(minimumDistance: 30, coordinateSpace: .local).onChanged { value in
                    switch self.activeView {
                    case .left:
//                            guard value.translation.width < 1 else { return }
                        self.viewState = value.translation
                    case .right:
                        guard value.translation.width > 1 else { return }
                        self.viewState = value.translation
                    case .center:
                        self.viewState = value.translation
                    }
                }
                    
                .onEnded { value in
                    switch self.activeView {
                    case .left:
                        if value.predictedEndTranslation.width > screenWidth / 2.4 {
                            self.activeView = .center
                                
                            simpleSuccess()
                            self.viewState = .zero
//                                print("left trans")
                        }
                        else {
                            self.viewState = .zero
                        }
                    case .right:
                        if value.predictedEndTranslation.height < -100 || value.predictedEndTranslation.width > screenWidth / 2.4 {
                            self.activeView = .center
                            withAnimation(.spring(dampingFraction: 0.7)){
                                self.showTopBar = true
                            }
                            simpleSuccess()
                            self.viewState = .zero
                        }
                        else {
                            self.viewState = .zero
                        }
                    case .center:
                        self.viewState = .zero
                    }
                }
        )
//            .onAppear {
//                withAnimation(.spring()) {
//                    appear = true
//                }
//                withAnimation(.easeOut(duration: 2)) {
//                    appearBackground = true
//                }
//            }
//            .onDisappear {
//                withAnimation(.spring()) {
//                    appear = false
//                }
//                withAnimation(.easeOut(duration: 1)) {
//                    appearBackground = true
//                }
//            }
//            .onChange(of: model.dismissModal) { _ in
//                dismissModal()
//
//            }
        .accessibilityAddTraits(.isModal)
    }
}

struct SwipeNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SwipeNavigationHome()
    }
}

extension SwipeNavigationHome {
    func dismissModal() {
        withAnimation {
            appear = false
            appearBackground = false
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.2)) {
                model.showModal = false
            }
        }
    }
}
