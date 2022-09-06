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
    var url: URL {
        URL(string: "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F201907%2F07%2F20190707005614_jcxtw.thumb.400_0.jpeg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1665027925&t=0a5313bed282f836019773c1f8b74d58")!
    }
    private var blackWhite = false
    private var forceTransition = true
    
    var body: some View {
        
        
        ZStack(alignment: .top) {
            KFImage(url)
                .setProcessor(blackWhite ? BlackWhiteProcessor() : DefaultImageProcessor())
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
                
                .aspectRatio(contentMode: .fill)
                .frame( width:UIScreen.main.bounds.width, height:UIScreen.main.bounds.height)
//                .scaledToFit()
                
                .ignoresSafeArea()
                
                .opacity(0.63)
                .blur(radius: 50)

            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                            .edgesIgnoringSafeArea(.all)
            
            CenterView(activeView: activeView)
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
            RightView(activeView: self.activeView)
                .offset(x: self.activeView == currentView.right ? 0 : screenWidth)
                .offset(x: activeView != .left ? viewState.width : 0)
//                .animation(.easeInOut(duration: 0.5))
                .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.9,blendDuration: 0.2))
        }
        
        .gesture(
            
            (self.activeView == currentView.center) ?
                
            DragGesture(minimumDistance: 30, coordinateSpace: .global).onChanged { value in
                    
                    self.viewState = value.translation
                    
                }
                .onEnded { value in
                    if value.predictedEndTranslation.width > screenWidth / 2 {
                        self.activeView = currentView.left
                        simpleSuccess()
                        self.viewState = .zero
                        
                    }
                    else if value.predictedEndTranslation.width < -screenWidth / 2 {
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
                        guard value.translation.width < 1 else { return }
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
                        if value.predictedEndTranslation.width < -screenWidth / 2 {
                            self.activeView = .center
                            simpleSuccess()
                            self.viewState = .zero
                        }
                        else {
                            self.viewState = .zero
                        }
                    case .right:
                        if value.predictedEndTranslation.width > screenWidth / 2 {
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
    }
}

struct SwipeNavigation_Previews: PreviewProvider {
    static var previews: some View {
        SwipeNavigationHome()
    }
}
