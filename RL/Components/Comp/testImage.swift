//
//  testImage.swift
//  RL
//
//  Created by Ryan Liu on 2022/9/14.
//

import SwiftUI

struct testImage: View {
    var body: some View {
        GeometryReader { geo in
            Image("bk2")
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
//                .ignoresSafeArea()
            
        }
        .ignoresSafeArea()
    }
}

struct testImage_Previews: PreviewProvider {
    static var previews: some View {
        testImage()
    }
}
