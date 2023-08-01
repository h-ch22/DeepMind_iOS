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
    @State private var helper = InspectionHelper()
    
    @Environment(\.presentationMode) var presentationMode
        
    private func drawImage(_ image: UIImage) -> UIImage?{
        guard let cgImage = image.cgImage else {return nil}
        UIGraphicsBeginImageContext(CGSize(width: 1280, height: 1280))
        image.draw(in: CGRect(x: 0, y: 0, width: 1280, height: 1280))
        
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }

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
                    
                    if drawingType == .PERSON_2{
                        Spacer().frame(height : 5)
                        
                        Text("첫번째 사람과 반대 성별로 그려주세요.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }

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
                                let img = drawImage(canvasView.asUIImage())
                                guard let image = img?.pngData() else {return}
                                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {return}
                                
                                do{
                                    try image.write(to: directory.appendingPathComponent("HOUSE.png")!)
                                    helper.detect()
                                    
                                    drawingType = .TREE
                                    canvasView.drawing = PKDrawing()
                                    timer = 0
                                }catch{
                                    print(error.localizedDescription)
                                }

                            case .TREE:
                                let img = drawImage(canvasView.asUIImage())
                                guard let image = img?.pngData() else {return}
                                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {return}
                                
                                do{
                                    try image.write(to: directory.appendingPathComponent("TREE.png")!)
                                    
                                    drawingType = .PERSON_1
                                    canvasView.drawing = PKDrawing()
                                    timer = 0
                                }catch{
                                    print(error.localizedDescription)
                                }
                                
                            case .PERSON_1:
                                let img = drawImage(canvasView.asUIImage())
                                guard let image = img?.pngData() else {return}
                                guard let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL else {return}
                                
                                do{
                                    try image.write(to: directory.appendingPathComponent("PERSON_1.png")!)
                                    
                                    drawingType = .PERSON_2
                                    canvasView.drawing = PKDrawing()
                                    timer = 0
                                }catch{
                                    print(error.localizedDescription)
                                }
                                
                            case .PERSON_2:
                                break
                            }
                        }){
                            Text(drawingType == .PERSON_2 ? "검사 종료" : "다음")
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
