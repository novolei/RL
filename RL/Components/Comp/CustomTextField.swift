//
//  CustomTextField.swift
//  Twitter Clone
//
//  Created by Scott Lau on 2021/5/22.
//

import SwiftUI

struct CustomTextField: View {
    
    @Binding var text: String
    let title: String
    let placeholder: String
    let imageName: String
    let autocapitalization: UITextAutocapitalizationType
    @Binding var showPassword: Bool
    var body: some View {
//        ZStack(alignment: .leading) {
//            if text.isEmpty {
//                Text(placeholder)
//                    .foregroundColor(Color(.init(white: 1, alpha: 0.87)))
//                    .padding(.leading, 40)
//            }
//
//            HStack(spacing: 16) {
//                Image(systemName: imageName)
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 20, height: 20)
//                    .foregroundColor(.white)
//
//                TextField("", text: $text)
//                    .autocapitalization(autocapitalization)
//            }
//        }
        
        VStack(alignment: .leading, spacing: 12) {
            
            Label {
                Text(title)
                    .font(.custom(customFont, size: 14))
            } icon: {
                Image(systemName: imageName)
            }
            .foregroundColor(Color.white.opacity(0.8))
            
            if title.contains("Password") && !$showPassword.wrappedValue{
                SecureField(placeholder, text: $text)
                    .font(.custom(customFont, size: 14))
                    .padding(.top,2)
            }
            else{
                TextField(placeholder, text: $text)
                    .font(.custom(customFont, size: 14))
                    .padding(.top,2)
            }
            
            Divider()
                .background(Color.white.opacity(0.94))
        }
        // Showing Show Button for password Field...
        .overlay(
        
            Group{
                
                if title.contains("Password"){
                    Button(action: {
                        $showPassword.wrappedValue.toggle()
                    }, label: {
                        Text($showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.custom(customFont, size: 13).bold())
                            .foregroundColor(.white)
                    })
                    .offset(y: 8)
                }
            }
            
            ,alignment: .trailing
        )
    }
}

//struct CustomTextField_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomTextField(text: .constant(""), placeholder: "Email", imageName: "envelope", autocapitalization: .none)
//    }
//}
