//
//  RegisterView.swift
//  Twitter Clone
//
//  Created by Scott Lau on 2021/5/22.
//

import AlertToast
import PhotosUI
import SwiftUI

struct RegisterView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var username = ""
    @State private var name = ""
//    @State private var showImagePicker = false
//    @State private var selectedUIImage: UIImage?
//    @State private var image: Image?
    @State private var errorMessage = ""
    @State private var showingAlert = false
    @State private var showPassword: Bool = false
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    let viewModel = AuthViewModel.shared
    @EnvironmentObject var imagePicker: ImagePicker
    @State private var showToast = false
//    @StateObject var authModel = AuthViewModel.shared
    @State private var info_message: String = ""
    @ObservedObject var authModel = AuthViewModel.shared
//    func loadImage() {
//        guard let selectedImage = selectedUIImage else {
//            return
//        }
//        image = Image(uiImage: selectedImage)
//    }
    
    var body: some View {
        ZStack {
            GeometryReader { proxy in
                
                if let image = imagePicker.image {
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: proxy.size.width, height: proxy.size.height)
//                        .ignoresSafeArea()
//                        .opacity(0.63)
                        .blur(radius: 3)
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
            VStack {
                PhotosPicker(selection: $imagePicker.imageSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    if let image = imagePicker.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 140, height: 120)
                            .clipShape(Circle())
                            .padding(.top, 77)
                            .padding(.bottom, 16)
                    } else {
                        Image("plus_photo")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFill()
                            .frame(width: 140, height: 120)
                            .padding(.top, 77)
                            .padding(.bottom, 16)
                            .foregroundColor(.white)
                    }
                }
                
                VStack(spacing: 20) {
                    CustomTextField(text: $email, title: "Email", placeholder: "电子邮箱", imageName: "envelope", autocapitalization: .none, showPassword: .constant(false))
                        .padding()
                        
                        .foregroundColor(.white)
                    
                    CustomTextField(text: $name, title: "Nick Name", placeholder: "昵称", imageName: "person", autocapitalization: .words, showPassword: .constant(false))
                        .padding()
                        
                        .foregroundColor(.white)
                    
                    CustomTextField(text: $username, title: "User Name", placeholder: "用户名", imageName: "person", autocapitalization: .none, showPassword: .constant(false))
                        .padding()
                        
                        .foregroundColor(.white)
                    CustomTextField(text: $password, title: "Password", placeholder: "Password", imageName: "lock", autocapitalization: .none, showPassword: $showPassword)
                        .padding()
                        
                        .foregroundColor(.white)
                }.padding(.horizontal, 32)
                
                Button(action: {
                    Task {
                        try await authModel.create(name: name, email: email, password: password) { error in
                            print("开始注册： \(error)")
                            if error != "" {
                                self.info_message = error
                                showingAlert = true
                                errorMessage = error
                            }
                        }
                        DispatchQueue.main.async {
                            self.info_message = authModel.suc_Msg
                            
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.9, blendDuration: 0.2)) {
                                if authModel.didAuthUser {
                                    mode.wrappedValue.dismiss()
                                }
                            }
                        }
                        
                    }
                    //                let user = User(email: email, username: username, name: name, password: password)
                    //                viewModel.signUp(user: user, profileImage: selectedUIImage ?? nil) { errorMessage in
                    //                    self.errorMessage = errorMessage
                    //                    self.showingAlert = true
                    //                }
                }, label: {
                    Text("注册")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .frame(height: 50)
                        .background(.ultraThinMaterial.opacity(0.4))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }).padding(.vertical)
                    .padding(.horizontal, 32)
                
                Spacer()
                
                HStack {
                    Text("已有帐号?")
                        .font(.system(size: 16))
                    
                    Button(
                        action: {
                            mode.wrappedValue.dismiss()
                        },
                        label: {
                            Text("立即登录")
                                .font(.system(size: 16, weight: .semibold))
                        }
                    )
                }.foregroundColor(.white)
                    .padding(.bottom, 55)
            }
            //        .background(Color(#colorLiteral(red: 0.1137796417, green: 0.6296399236, blue: 0.9523974061, alpha: 1)))
            .ignoresSafeArea()
        }
        .toast(isPresenting: $authModel.didAuthUser) {
            // `.alert` is the default displayMode
            AlertToast(type: .complete(.green.opacity(0.63)), title: self.info_message)
                
            // Choose .hud to toast alert from the top of the screen
            // AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
                    
            // Choose .banner to slide/pop alert from the bottom of the screen
            // AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
        }
        .toast(isPresenting: $showingAlert) {
            // `.alert` is the default displayMode
            AlertToast(type: .error(.red.opacity(0.63)), title: self.errorMessage)
                
            // Choose .hud to toast alert from the top of the screen
            // AlertToast(displayMode: .hud, type: .regular, title: "Message Sent!")
                    
            // Choose .banner to slide/pop alert from the bottom of the screen
            // AlertToast(displayMode: .banner(.slide), type: .regular, title: "Message Sent!")
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
//        .alert(isPresented: $showingAlert) {
//            Alert(title: Text("\(errorMessage)"), dismissButton: .default(Text("好的")))
//        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
