//
//  DiaryMarkUpView.swift
//  DeepMind
//
//  Created by 하창진 on 8/7/23.
//

import SwiftUI
import PencilKit

struct DiaryMarkUpView: View {
    @State private var canvasView = PKCanvasView()
    @Binding var images: [UIImage]
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            VStack{
                DiaryCanvasView(canvas: $canvasView)
            }.padding(20).toolbar{
                ToolbarItemGroup(placement: .topBarLeading){
                    Button("취소"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing){
                    Button("완료"){
                        images.append(canvasView.asUIImage())
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

#Preview {
    DiaryMarkUpView(images: .constant([]))
}
