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

import SwiftUI
import Kingfisher

struct SwipeNavigationHome: View {
    @State var activeView = currentView.center
    @State var viewState = CGSize.zero
    
    @State var appear = false
    @State var appearBackground = false
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var model: Model
    var url: URL {
        URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fpic.soutu123.com%2Fback_pic%2F04%2F06%2F11%2F33580f081a7b447.jpg%21%2Ffw%2F700%2Fquality%2F90%2Funsharp%2Ftrue%2Fcompress%2Ftrue&refer=http%3A%2F%2Fpic.soutu123.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665636366&t=8e7ec3962f2281774ff3ce4056a76d13")!
    }
    private var blackWhite = false
    private var forceTransition = true
    
    
    var body: some View {
        
        
        GeometryReader { proxy in
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
                    
//                    .aspectRatio(contentMode: .fit)
                    .frame( width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
                    .scaledToFit()
                    
                    .ignoresSafeArea()
                    
                    .opacity(appear ? 0.63 : 0.7)
                    .blur(radius: 5)

                
                VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                    .ignoresSafeArea()
                ZStack {
                    HStack(alignment: .center) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.title3)
                                .foregroundColor(.white)
                        }

                        
                        Spacer()
                        
                        Image(systemName: "gear")
                            .font(.title3)
                            .foregroundColor(.white)
                        
                    }.padding()
                    Text("chatUser.name")
                        .font(.custom(customFont, size: 16))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                }
                .padding(.horizontal,5)
    //            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialLight))
    //                            .edgesIgnoringSafeArea(.all)
                CenterView(activeView: .center)
                    .scaleEffect(activeView == .center && viewState.width == .zero ? 1 :  0.85)
    //                .opacity(activeView == .center ? (viewState.width == .zero ? 1 : (0.5 - abs(viewState.width/screenWidth))) : 0)
                    .opacity(activeView == .center && viewState.width == .zero ? 1 :  0)
                    .blur(radius: activeView == .center ? (viewState.width == .zero ? 0 : 3) : 0)
    //                .animation(.easeInOut(duration: 0.5))
                    .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9,blendDuration: 0.3))
                
                LeftView(activeView: activeView)
                    .offset(x: self.activeView == currentView.left ? 0 : -screenWidth)
                    .offset(x: activeView != .right ? viewState.width : 0)
    //                .animation(.easeInOut(duration: 0.5))
                    .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9,blendDuration: 0.4))
                    .opacity(appear ? 1 : 0)
                RightView(activeView: self.activeView)
                    .offset(x: self.activeView == currentView.right ? 0 : screenWidth)
                    .offset(x: activeView != .left ? viewState.width : 0)
    //                .animation(.easeInOut(duration: 0.5))
                    .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9,blendDuration: 0.2))
                    .zIndex(200)
                
                Button {
                    dismissModal()
                } label: {
                    CloseButton()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding()
                .offset(y: 20)
                
            }
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
                        if value.predictedEndTranslation.width > screenWidth / 2.8 && value.startLocation.x < screenWidth/4 {
//                            self.activeView = currentView.left
//                            dismissModal()
//                            simpleSuccess()
                            self.viewState = .zero
                            print("left trans")
                            simpleSuccess()
                            presentationMode.wrappedValue.dismiss()
                            
                        }
                        //&& value.startLocation.x < screenWidth-120 && value.startLocation.x > screenWidth/4*3
                        else if value.predictedEndTranslation.width < -screenWidth / 3.8 {
                            self.activeView = currentView.right
                            simpleSuccess()
                            self.viewState = .zero
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
                        case.center:
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
                            if  value.predictedEndTranslation.height < -100 || value.predictedEndTranslation.width > screenWidth / 2.4 {
                                self.activeView = .center
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
            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.9,blendDuration: 0.2)){
                model.showModal = false
            }
        }
    }
}
