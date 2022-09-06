//
//  RightView.swift
//  uiPlayground
//
//  Created by Ryan Remaly on 2/13/21.
//
import SwiftUI
struct selfTabs: View {
//    @Binding var showTabs: Bool
    var body: some View {
        TabView {
            VStack() {
                ZStack {
                    Rectangle()
                        .foregroundColor(.blue)
                        .cornerRadius(20)
                        .frame(width: 320, height: 320)
                    .padding()
                    Text("111").frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                Spacer()
               
                    
               
            }
            .padding()
            VStack {
                Text("222").frame(maxWidth: .infinity, maxHeight: .infinity)
            }.background(.green)
                .cornerRadius(20)
                .padding()
        }
//        .overlay(alignment: .topTrailing) {
//            Button("dismiss") {
//
////                    showTabs = false
//
//            }
//            .buttonStyle(.bordered)
//            .padding(.vertical, 100)
//            .padding(.horizontal, 20)
//        }
        .tabViewStyle(.page(indexDisplayMode: .always))
    }
}
struct RightView: View {
    @State var activeView: currentView
    
    var body: some View {
        GeometryReader { bounds in
            VStack {
                selfTabs()
                 .zIndex(1)
                
                Spacer()
                Text("   ")
                    .padding(.bottom, 145)
                    
                
            }
            .frame(width: bounds.size.width, height: bounds.size.height, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
//        .background(Color.green)
        .edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
    }
}

struct RightView_Previews: PreviewProvider {
    static var previews: some View {
        RightView(activeView: .right)
    }
}
