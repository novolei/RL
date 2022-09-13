//
//  LoginView.swift
//  Twitter Clone
//
//  Created by Scott Lau on 2021/5/22.
//

import SwiftUI

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage = ""
    @State private var showingAlert = false
    let viewModel = AuthViewModel.shared
    @State private var showPassword: Bool = false
    @EnvironmentObject var imagePicker: ImagePicker
    
    var body: some View {
        ZStack {
            

            NavigationView {
                ZStack {
                    GeometryReader { proxy in
                        if let image = imagePicker.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: proxy.size.width, height: proxy.size.height)
//                                .ignoresSafeArea()
//                                .opacity(0.63)
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
                                .blur(radius: 21)
                        }
                    }
                    
                    VisualEffectBlur(blurStyle: .systemUltraThinMaterialDark)
                        .ignoresSafeArea()
                    VStack {
                        Image("icon")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 120)
                            .clipShape(Circle())
                            .shadow(radius: 3)
                            .padding(.top, 77)
                            .padding(.bottom, 22)
                        
                        VStack(spacing: 20) {
                            CustomTextField(text: $username, title: "User Name", placeholder: "用户名", imageName: "person", autocapitalization: .none, showPassword: .constant(false))
//                            CustomTextField(icon: "person", title: "User name", hint: "Ryan", value: $username, showPassword: .constant(false))
//                                .padding(.top,15)
                                .padding()
    //                            .background(Color(.init(white: 1, alpha: 0.15)))
//                                .background(.ultraThinMaterial)
                                .cornerRadius(10)
                                .foregroundColor(.white)
                            CustomTextField(text: $password, title: "Password",placeholder: "123456",imageName: "lock",    autocapitalization: .none, showPassword: $showPassword)
//                                .padding(.top,10)
                                .padding()
                                .foregroundColor(.white)
//                            CustomSecureField(text: $password, placeholder: "密码")
//                                .padding()
    //                            .background(Color(.init(white: 1, alpha: 0.15)))
//                                .background(.ultraThinMaterial)
//                                .cornerRadius(10)
//                                .foregroundColor(.white)
                        }.padding(.horizontal, 32)
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {}, label: {
                                Text("忘记密码?")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                    .padding(.trailing, 32)
                            })
                        }
                        
                        Button(action: {
                            //                    viewModel.signIn(withUsername: username, password: password) { errorMessage in
                            //                        self.errorMessage = errorMessage
                            //                        self.showingAlert = true
                            //                    }
                        }, label: {
                            Text("登录")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 50)
    //                            .background(Color.white)
                                .background(.ultraThinMaterial.opacity(0.4))
                                
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }).padding(.vertical)
                            .padding(.horizontal, 32)
                        
                        Spacer()
                        
                        HStack {
                            Text("还没有帐号?")
                                .font(.system(size: 16))
                            
                            NavigationLink(
                                destination: RegisterView()
                                    .navigationBarBackButtonHidden(true),
                                label: {
                                    Text("立即注册")
                                        .font(.system(size: 16, weight: .semibold))
                                }
                            )
                        }.foregroundColor(.white)
                            .padding(.bottom, 40)
                    }
                    .background(Color.clear)
    //                .background(Color(#colorLiteral(red: 0.1137796417, green: 0.6296399236, blue: 0.9523974061, alpha: 1)))
                .ignoresSafeArea()
                }
            }
//            .navigationBarColor(.green)
            .background(Color.clear)
            .onTapGesture {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("\(errorMessage)"), dismissButton: .default(Text("好的")))
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
