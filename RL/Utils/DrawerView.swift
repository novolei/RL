//
//  DrawerView.swift
//  DrawerView
//
//  Created by jaydeep on 07/04/22.
//

import SwiftUI

struct DrawerView<MainContent: View, DrawerContent: View>: View {
    private let overlap: CGFloat = 1
    private let overlayColor = Color.gray
    private let overlayOpacity = 0.7
    private let dragOpenThreshold = 0.1

    @Binding var isOpen: Bool
    @State private var openFraction: CGFloat
    private let main: () -> MainContent
    private let drawer: () -> DrawerContent

    init(isOpen: Binding<Bool>,
         @ViewBuilder main: @escaping () -> MainContent,
         @ViewBuilder drawer: @escaping () -> DrawerContent)
    {
        self._isOpen = isOpen
        self.openFraction = isOpen.wrappedValue ? 1 : 0
        self.main = main
        self.drawer = drawer
    }

    var body: some View {
        GeometryReader { proxy in
            let drawerWidth = proxy.size.width * overlap
            ZStack(alignment: .topLeading) {
                main()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .opacity(Double(1 - openFraction))
                    .blur(radius: 15 * openFraction)
//                    .scaleEffect(1 - openFraction*0.3 )
//                    .overlay(mainOverlay)
//                    .zIndex(-100)
                
                drawer()
                    .frame(minWidth: drawerWidth, idealWidth: drawerWidth,
                           maxWidth: drawerWidth, maxHeight: .infinity)
                    .offset(x: xOffset(drawerWidth), y: 0)
            }
            .gesture(dragGesture(proxy.size.width))
            .onChange(of: isOpen) { newValue in
                withAnimation(.easeInOut) {
                    self.openFraction = newValue ? 1 : 0
                }
            }
        }
    }

    private var mainOverlay: some View {
        VStack {
            if openFraction == 0 {
                Color.clear
            } else {
                overlayColor.opacity(openFraction)
            }

        }
        .ignoresSafeArea()
        .onTapGesture {
            withAnimation {
                isOpen.toggle()
            }
        }
    }

    private func dragGesture(_ mainWidth: CGFloat) -> some Gesture {
        return DragGesture(minimumDistance: 24).onChanged { value in
            if isOpen, value.translation.width < 0 {
                openFraction = openFraction(value.translation.width, from: -mainWidth...0)
            } else if !isOpen, value.startLocation.x < mainWidth * dragOpenThreshold, value.translation.width > 0 {
                openFraction = openFraction(value.translation.width, from: 0...mainWidth)
            } else {
                // Drawer is open and user is trying to drag from left to right
                // OR
                // Drawer is closed and user is trying to drag from right to left
                // Ignore both gestures.
            }
        }.onEnded { value in
            if openFraction == 1 || openFraction == 0 {
                return
            }
            let fromRange = isOpen ? -mainWidth...0 : 0...mainWidth
            let predictedMoveX = value.predictedEndTranslation.width
            let predictedOpenFraction = openFraction(predictedMoveX, from: fromRange)
            if predictedOpenFraction > 0.5 {
                withAnimation {
                    openFraction = 1
                    isOpen = true
                }
            } else {
                withAnimation {
                    openFraction = 0
                    isOpen = false
                }
            }
        }
    }

    private func remap(_ value: CGFloat, from source: ClosedRange<CGFloat>, to target: ClosedRange<CGFloat>) -> CGFloat {
        let targetDiff = target.upperBound - target.lowerBound
        let sourceDiff = source.upperBound - source.lowerBound
        return (value - source.lowerBound) * targetDiff / sourceDiff + target.lowerBound
    }

    private func xOffset(_ drawerWidth: CGFloat) -> CGFloat {
        remap(openFraction, from: 0...1, to: -drawerWidth...0)
    }

    private func openFraction(_ moveX: CGFloat, from source: ClosedRange<CGFloat>) -> CGFloat {
        remap(moveX, from: source, to: 0...1)
    }
}

struct DrawerView_Previews: PreviewProvider {
    static var previews: some View {
        DrawerView(isOpen: .constant(true)) {
            Color.red
            Text("Show drawer")
        } drawer: {
            Color.green
            Text("Drawer Content")
        }
    }
}
