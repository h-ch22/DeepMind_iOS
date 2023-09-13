//
//  ViewSizeCalculator.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/14/23.
//

import SwiftUI

struct ViewSizeCalculator: ViewModifier {
    
    @Binding var size: CGSize
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .onAppear {
                            size = proxy.size
                        }
                }
            )
    }
}
