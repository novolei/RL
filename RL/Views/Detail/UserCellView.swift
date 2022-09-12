//
//  UserCellView.swift
//  NoSignal
//
//  Created by Ryan Liu on 2022/8/7.
//

import SwiftUI

struct UserCellView: View {
    @State var readOr: Bool
    @State var tapped: Bool = false

    var body: some View {
        VStack {
            HStack(alignment: .center, spacing: 18) {
                Image("Avatar 3")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 28, height: 28)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Ryan Liu")
                        .font(.custom(customFont, size: 14))
                        .fontWeight(.semibold)
                    Text("Hey How are you!?")
                        .font(.custom(customFont, size: 11))
                        .fontWeight(.light)
                }
                .foregroundColor(.white)
                Spacer()
                VStack(alignment: .trailing) {
                    Text("15:20PM")
                        .font(.custom(customFont, size: 13))
                        .fontWeight(.semibold)

                    if readOr {
                        Image(systemName: "checkmark.diamond.fill")
                            .font(.subheadline)
                            //                        .resizable()
                            //                        .scaledToFit()
                            //                        .frame(width: 16)
                            .foregroundColor(.green)
                    } else {
                        Text("2")
                            .font(.custom(customFont, size: 12))
                            .fontWeight(.semibold)
                            .frame(width: 16, height: 16)
                            .background(.red)
                            .clipShape(Circle())
                    }
                }
                .foregroundColor(.white)
            }
            .padding(.horizontal)
            .frame(height: 60)
            Divider()
                .background(.white.opacity(0.6))
                .padding(.top, 5)
                .padding(.leading, 55 )
            
        }
        
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(readOr: true)
    }
}
