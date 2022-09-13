//
//  MainEntry.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/7.
//

import Kingfisher
import SwiftUI

// To Use the custom font on all pages..
let customFont = "Raleway-Regular"

struct MainEntry: View {
    var columns = [GridItem(.adaptive(minimum: 300), spacing: 20)]
    @AppStorage("showAccount") var showAccount = false
    @AppStorage("isLogged") var isLogged = false
    @State private var contentSize: CGSize = .zero
    @EnvironmentObject var imagePicker:ImagePicker
    @EnvironmentObject var model: Model
    @State var show = false
    @State var showStatusBar = true
    @State var showCourse = false
    @State var selectedCourse: Course = courses[0]
    @State var contentHasScrolled = false
    private var blackWhite = false
    private var forceTransition = true
    @State var viewState = CGSize.zero
    @Namespace var namespace
    var url: URL {
        URL(string: "https://t7.baidu.com/it/u=1951548898,3927145&fm=193&f=GIF")!
    }

    var chatType: String = "Friend"
    @State var selectIdx: Int32 = -1
    var body: some View {
        ZStack {
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
                            //                .scaledToFit()
                            .ignoresSafeArea()
                            .opacity(0.63)
                            .blur(radius: 50)
                    } else {
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

                ScrollView {
                    scrollDetection

                    VStack(spacing: 0) {
                        ForEach(0 ... 56, id: \.self) { index in
                            NavigationLink(destination: SwipeNavigationHome()) {
                                UserCellView(readOr: true)

                                    .background(selectIdx == index ? Color.black.opacity(0.1) : Color.clear)
                                    .contentShape(Rectangle())

//                                    .onTapGesture {
//                                        selectIdx = Int32(index)
//                                }
                            }
                            .navigationBarTitle("")    // <-- you add this line
                                .navigationBarHidden(true)
                                .navigationBarBackButtonHidden(true)
                                //.edgesIgnoringSafeArea(.all)
                        }
                        //                    .background(.red)
                    }
                }
                .padding(.top, 45)
                .padding(.bottom, 45)
                .coordinateSpace(name: "scroll")
                
            }
            .onChange(of: model.showDetail) { _ in
                withAnimation {
                    model.showTab.toggle()
                    model.showNav.toggle()
                    showStatusBar.toggle()
                }
            }
            .overlay(NavigationBar(title: "Featured", contentHasScrolled: $contentHasScrolled)
                .padding(.horizontal, 12))
            .dynamicTypeSize(.large ... .xxLarge)
            .sheet(isPresented: $showAccount) {
                AccountView()
            }

            if model.showModal {
//                ModalView()
                SwipeNavigationHome()

                    .transition(.customTransition)
                    .accessibilityIdentifier("Identifier")
            }
        }
    }

    var detail: some View {
        ForEach(featuredCourses) { course in
            if course.index == model.selectedCourse {
                CourseView(namespace: namespace, course: .constant(course))
            }
        }
    }

    var course: some View {
        ForEach(featuredCourses) { course in
            CourseItem(namespace: namespace, course: course)
                .accessibilityElement(children: .combine)
                .accessibilityAddTraits(.isButton)
        }
    }

    var featured: some View {
        TabView {
            ForEach(courses) { course in
                GeometryReader { proxy in
                    FeaturedItem(course: course)
                        .cornerRadius(30)
                        .modifier(OutlineModifier(cornerRadius: 30))
                        .rotation3DEffect(
                            .degrees(proxy.frame(in: .global).minX / -10),
                            axis: (x: 0, y: 1, z: 0), perspective: 1
                        )
                        .shadow(color: Color("Shadow").opacity(0.3),
                                radius: 30, x: 0, y: 30)
                        .blur(radius: abs(proxy.frame(in: .global).minX) / 40)
                        .overlay(
                            Image(course.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .offset(x: 32, y: -80)
                                .frame(height: 230)
                                .offset(x: proxy.frame(in: .global).minX / 2)
                        )
                        .padding(20)
                        .onTapGesture {
                            showCourse = true
                            selectedCourse = course
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityAddTraits(.isButton)
                }
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .frame(height: 460)
        .background(
            Image("Blob 1")
                .offset(x: 250, y: -100)
                .accessibility(hidden: true)
        )
        .sheet(isPresented: $showCourse) {
            CourseView(namespace: namespace, course: $selectedCourse, isAnimated: false)
        }
    }

    var scrollDetection: some View {
        GeometryReader { proxy in
            let offset = proxy.frame(in: .named("scroll")).minY
            Color.clear.preference(key: ScrollPreferenceKey.self, value: offset)
        }
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut) {
                if value < 0 {
                    contentHasScrolled = true
                } else {
                    contentHasScrolled = false
                }
            }
        }
    }
}

struct MainEntry_Previews: PreviewProvider {
    static var previews: some View {
        MainEntry()
    }
}

extension AnyTransition {
    static var customTransition: AnyTransition {
        let insertion = AnyTransition.move(edge: .trailing)
            // .combined(with: .scale(scale: 0.2, anchor: .topTrailing))
            .combined(with: .opacity)
        let removal = AnyTransition.move(edge: .trailing)
        return .asymmetric(insertion: insertion, removal: removal)
    }
}
