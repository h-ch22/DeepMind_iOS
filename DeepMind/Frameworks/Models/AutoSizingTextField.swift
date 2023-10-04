//
//  AutoSizingTextField.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI

struct AutoSizingTextField : UIViewRepresentable{
    var hint : String
    typealias UIViewType = UITextView
    
    @Binding var text : String
    @Binding var containerHeight : CGFloat
    
    func makeCoordinator() -> Coordinator {
        return AutoSizingTextField.Coordinator(parent : self)
    }
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.text = hint
        textView.textColor = .gray
        textView.delegate = context.coordinator
        textView.backgroundColor = UIColor(.clear)
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        DispatchQueue.main.async{
            if containerHeight == 0{
                containerHeight = uiView.contentSize.height
            }
            
            if context.coordinator.parent.text == ""{
                uiView.text = hint
                uiView.textColor = .gray
                uiView.delegate = context.coordinator
                uiView.backgroundColor = UIColor(.clear)
                
                self.hideKeyboard()
            }
        }
    }
    
    class Coordinator : NSObject, UITextViewDelegate{
        var parent : AutoSizingTextField
        
        init(parent : AutoSizingTextField){
            self.parent = parent
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            if textView.text == parent.hint{
                textView.text = ""
                textView.textColor = UIColor(.white)
            }
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            parent.containerHeight = textView.contentSize.height
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            if textView.text == ""{
                textView.text = parent.hint
                textView.textColor = .gray
            }
            
        }
    }
}
