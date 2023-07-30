//
//  DrawingView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI
import PencilKit

struct DrawingView: View {
    @State private var canvasView = PKCanvasView()
    @State private var isDraw = true
    @State private var color : Color = .black
    @State private var type : PKInkingTool.InkType = .pencil
    @State private var timer = 0
    @State private var drawingType: DrawingTypeModel = .HOUSE
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView{
            VStack{
                HStack{
                    Button(action: {
                        isDraw = true
                    }){
                        Image(systemName : isDraw ? "pencil.line" : "pencil")
                            .font(.title)
                            .foregroundStyle(isDraw ? Color.accentColor : Color.gray)
                    }
                    
                    Spacer().frame(width : 10)
                    
                    Button(action: {
                        isDraw = false
                    }){
                        Image(systemName: !isDraw ? "eraser.line.dashed.fill" : "eraser")
                            .font(.title)
                            .foregroundStyle(!isDraw ? Color.accentColor : Color.gray)
                    }
                    
                    Spacer()
                    
                    Text("\(drawingType.description)을 그려주세요.")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)

                    Spacer()
                    
                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Image(systemName : "xmark.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.gray)
                    }
                }
                
                Spacer().frame(height : 20)
                
                CanvasView(canvas: $canvasView, isDraw: $isDraw, type: $type, color: $color)
            }.padding(20)
                .onAppear{
                    Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true){ timer in
                        self.timer += 1
                    }
                }
                .toolbar{
                    ToolbarItemGroup(placement: .bottomBar){
                        Text(String(format: "%02d:%02d", timer / 60, timer % 60))
                            .foregroundStyle(Color.accentColor)
                        
                        Button(action: {
                            switch drawingType{
                            case .HOUSE:
                                timer = 0
                                drawingType = .TREE
                                
                            case .TREE:
                                timer = 0
                                drawingType = .PERSON
                                
                            case .PERSON:
                                break
                            }
                        }){
                            Text(drawingType == .PERSON ? "검사 종료" : "다음")
                        }
                    }
                }
                
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)

    }
}

#Preview {
    DrawingView()
}
