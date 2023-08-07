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
    @State private var showProgress = false
    
    @Environment(\.presentationMode) var presentationMode
    
    private let ciContext = CIContext()

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
                    
                    VStack{
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
                        
                        if !showProgress{
                            Button(action: {
                                showProgress = true
                                
                                DispatchQueue.main.async{
                                    switch drawingType{
                                    case .HOUSE:
                                        var resizedPixelBuffer: CVPixelBuffer?
                                        let status = CVPixelBufferCreate(nil, 1280, 1280, kCVPixelFormatType_32BGRA, nil, &resizedPixelBuffer)
                                        
                                        if status != kCVReturnSuccess{
                                            showProgress = false
                                            print("Error: Could not create resized pixel buffer : ", status)
                                        }
                                        
                                        guard let resizedPixelBuffer = resizedPixelBuffer else{
                                            showProgress = false
                                            return
                                        }
                                        let img = canvasView.asUIImage()
                                        
                                        let pixelBuffer = img.pixelBuffer(width: 1280, height: 1280)
                                        
                                        if pixelBuffer != nil{
                                            let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
                                            let sx = CGFloat(1280) / CGFloat(CVPixelBufferGetWidth(pixelBuffer!))
                                            let sy = CGFloat(1280) / CGFloat(CVPixelBufferGetHeight(pixelBuffer!))
                                            let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
                                            let scaledImage = ciImage.transformed(by: scaleTransform)
                                            ciContext.render(scaledImage, to: resizedPixelBuffer)
                                            
                                            if let boundingBoxes = try? helper.predict_CL01(image: resizedPixelBuffer){
                                                print(boundingBoxes)
                                            }

                                        }
                                        
                                        drawingType = .TREE
                                        canvasView.drawing = PKDrawing()
                                        timer = 0
                                        showProgress = false

                                    case .TREE:
                                        var resizedPixelBuffer: CVPixelBuffer?
                                        let status = CVPixelBufferCreate(nil, 1280, 1280, kCVPixelFormatType_32BGRA, nil, &resizedPixelBuffer)
                                        
                                        if status != kCVReturnSuccess{
                                            print("Error: Could not create resized pixel buffer : ", status)
                                        }
                                        
                                        let img = canvasView.asUIImage()
                                        
                                        let pixelBuffer = img.pixelBuffer(width: 1280, height: 1280)
                                        
                                        if pixelBuffer != nil{
                                            let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
                                            let sx = CGFloat(1280) / CGFloat(CVPixelBufferGetWidth(pixelBuffer!))
                                            let sy = CGFloat(1280) / CGFloat(CVPixelBufferGetHeight(pixelBuffer!))
                                            let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
                                            let scaledImage = ciImage.transformed(by: scaleTransform)
                                            ciContext.render(scaledImage, to: resizedPixelBuffer!)
                                            
                                            if let boundingBoxes = try? helper.predict_CL02(image: resizedPixelBuffer!){
                                                print(boundingBoxes)
                                            }
                                        }
                                        
                                        drawingType = .PERSON_1
                                        canvasView.drawing = PKDrawing()
                                        timer = 0
                                        showProgress = false
                                        
                                    case .PERSON_1:
                                        var resizedPixelBuffer: CVPixelBuffer?
                                        let status = CVPixelBufferCreate(nil, 1280, 1280, kCVPixelFormatType_32BGRA, nil, &resizedPixelBuffer)
                                        
                                        if status != kCVReturnSuccess{
                                            print("Error: Could not create resized pixel buffer : ", status)
                                        }
                                        
                                        let img = canvasView.asUIImage()
                                        
                                        let pixelBuffer = img.pixelBuffer(width: 1280, height: 1280)
                                        
                                        if pixelBuffer != nil{
                                            let ciImage = CIImage(cvPixelBuffer: pixelBuffer!)
                                            let sx = CGFloat(1280) / CGFloat(CVPixelBufferGetWidth(pixelBuffer!))
                                            let sy = CGFloat(1280) / CGFloat(CVPixelBufferGetHeight(pixelBuffer!))
                                            let scaleTransform = CGAffineTransform(scaleX: sx, y: sy)
                                            let scaledImage = ciImage.transformed(by: scaleTransform)
                                            ciContext.render(scaledImage, to: resizedPixelBuffer!)
                                            
                                            if let boundingBoxes = try? helper.predict_CL03(image: resizedPixelBuffer!){
                                                print(boundingBoxes)
                                            }
                                        }
                                        
                                        drawingType = .PERSON_2
                                        canvasView.drawing = PKDrawing()
                                        timer = 0
                                        showProgress = false
                                        
                                    case .PERSON_2:
                                        break
                                    }
                                }
   
                            }){
                                Text(drawingType == .PERSON_2 ? "검사 종료" : "다음")
                            }
                        } else{
                            ProgressView()
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
