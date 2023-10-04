//
//  BlurView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI

struct BlurView: UIViewRepresentable {
    var style : UIBlurEffect.Style
    typealias UIViewType = UIVisualEffectView
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect : UIBlurEffect(style: style))
        
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        
    }
}
