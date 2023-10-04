//
//  KeyboardView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI

struct KeyboardView<Content, ToolBar> : View where Content : View, ToolBar: View {
    @StateObject private var keyboard: KeyboardResponder = KeyboardResponder()
    let toolbarFrame: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 40.0)
    var content: () -> Content
    var toolBar: () -> ToolBar
    
    var body: some View {
        ZStack {
            content()
                .padding(.bottom, (keyboard.currentHeight == 0) ? 0 : toolbarFrame.height)
            VStack {
                 Spacer()
                 toolBar()
                    .frame(width: toolbarFrame.width, height: toolbarFrame.height)
                    .background(Color.backgroundColor)
            }.opacity((keyboard.currentHeight == 0) ? 0 : 1)
            .animation(.easeOut)
        }
        .padding(.bottom, keyboard.currentHeight)
        .edgesIgnoringSafeArea(.bottom)
        .animation(.easeOut)
        
    }
}
