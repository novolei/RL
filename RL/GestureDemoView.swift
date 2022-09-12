//
//  GestureDemoView.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/5.
//

import Kingfisher
import SwiftUI

// let screenSize = UIScreen.main.bounds
// let screenWidth = screenSize.width
// let screenHeight = screenSize.height

func simpleSuccess() {
    let generator = UINotificationFeedbackGenerator()
    generator.notificationOccurred(.success)
}

struct GestureDemoView: View {
    @State var offSetX: CGFloat = UIScreen.main.bounds.width
    @State var showTabs = false
    @State var transationDis: CGFloat = 120
    @State var viewState = CGSize.zero

    var gesture: some Gesture {
        DragGesture(minimumDistance: 30, coordinateSpace: .local)
            .onChanged { value in
                self.viewState = value.translation
                let width = value.translation.width
                
                // let startX = value.startLocation.x
//                let startY = value.startLocation.y
//                let screenWidth = UIScreen.main.bounds.width
//                let screenHeight = UIScreen.main.bounds.height
                //  let rangeX: ClosedRange<CGFloat> = screenWidth-50 ... screenWidth
//                let rangeY: ClosedRange<CGFloat> = screenHeight-150 ... screenHeight
                
//                if rangeX.contains(startX) && width < 0  {
//                    transationDis = value.translation.width
//                }
                if width < -120 && abs(value.translation.height) < 50 {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        offSetX = UIScreen.main.bounds.width + width
                    }
                }
            }
            .onEnded { value in
                
//                let width = value.translation.width
//                let height = abs(value.translation.height)
//                if width < -100 && height < 120 {
//                    withAnimation(.interactiveSpring()) {
//                        offSetX = 0
//
//                    }
//                    showTabs = true
//                }
//                else {
//                    withAnimation(.interactiveSpring()) {
//                        offSetX = UIScreen.main.bounds.width
//                        transationDis = 120
//                        showTabs = false
//                    }
//                }
                if value.predictedEndTranslation.width > screenWidth / 2 && value.predictedEndTranslation.height < screenHeight / 2
                {
                    print("left  swipe")
                    self.viewState = .zero
                }
                else if value.predictedEndTranslation.width < -screenWidth / 2 && value.predictedEndTranslation.height > -screenHeight / 2
                {
                    print("right  swipe")
                    withAnimation(.interactiveSpring()) {
                        offSetX = 0
                    }
                    self.viewState = .zero
                    simpleSuccess()
                }
                                    
                else {
                    if self.viewState.width < 0 {}
                    withAnimation(.interactiveSpring()) {
                        offSetX = UIScreen.main.bounds.width
//                                            simpleSuccess()
                    }
                    self.viewState = .zero
                }
            }
    }

    var url: URL {
        URL(string: "https://raw.githubusercontent.com/onevcat/Kingfisher-TestImages/master/DemoAppImage/Loading/kingfisher-1.jpg")!
    }

    private var blackWhite = false
    private var forceTransition = true
//    let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
//                 |> RoundCornerImageProcessor(cornerRadius: 20)
    var body: some View {
        ZStack {
//            Color.secondary
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
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//                .scaledToFit()
                
                .ignoresSafeArea()
                
                .opacity(0.63)
                .blur(radius: 50)

            VisualEffectView(effect: UIBlurEffect(style: .systemUltraThinMaterialDark))
                .edgesIgnoringSafeArea(.all)
            VStack {
                Text("sdsds")
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(.secondary)
                    .frame(width: 320, height: 320)
            }.shadow(color: .red, radius: 2)
                
//            NavigationView {
//
                ////                Text("Hello world")
                ////                    .navigationTitle("Hello")
//
                ////                    .border(Color.red)
                ////                    .shadow(radius: 5)
                ////                    .frame(width: 320, height: 320)
//            }
                .opacity(offSetX / UIScreen.main.bounds.width)
//            .offset(x: -(UIScreen.main.bounds.width-offSetX)/3, y: 0)
                .scaleEffect(offSetX / UIScreen.main.bounds.width)
                .animation(.easeInOut(duration: 0.3))
            
            VStack {
                Tabs(showTabs: $showTabs)
                    .offset(x: offSetX, y: 0)
                    .zIndex(1)
                
                Text("test")
                    .padding(.bottom, 45)
                    .opacity(Double(1 - offSetX / UIScreen.main.bounds.width))
            }
        }
        .edgesIgnoringSafeArea(.all)
        .simultaneousGesture(gesture)
//        .gesture(gesture)
        .onChange(of: showTabs) { _ in
            if !showTabs {
                withAnimation(.interactiveSpring()) {
                    offSetX = UIScreen.main.bounds.width
                }
            }
        }
    }
}

struct Tabs: View {
    @Binding var showTabs: Bool
    var body: some View {
        TabView {
            VStack {
                Rectangle()
                    .foregroundColor(.blue)
                    .cornerRadius(20)
                    .padding()
                    
                Text("111").frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            VStack {
                Text("222").frame(maxWidth: .infinity, maxHeight: .infinity)
            }.background(.green)
                .cornerRadius(20)
                .padding()
        }
        .overlay(alignment: .topTrailing) {
            Button("dismiss") {
                showTabs = false
            }
            .buttonStyle(.bordered)
            .padding(.vertical, 100)
            .padding(.horizontal, 20)
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
    }
}

struct GestureDemoView_Previews: PreviewProvider {
    static var previews: some View {
        GestureDemoView()
    }
}

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView { UIVisualEffectView() }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) { uiView.effect = effect }
}
