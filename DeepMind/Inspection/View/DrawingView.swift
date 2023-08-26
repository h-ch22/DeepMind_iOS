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
    @State private var showErrorAlert = false
    @State private var isDetecting = false
    @State private var detectType : DrawingTypeModel? = .HOUSE
    @State private var detectingError: DrawingTypeModel? = nil
    @State private var isDetectComplete = false
    @State private var showResult = false
    @State private var docId = ""
    @State private var elapsedTimes: [Int] = []
    
    @Environment(\.presentationMode) var presentationMode
    
    private let ciContext = CIContext()
    
    var body: some View {
        NavigationView{
            if isDetecting{
                ZStack{
                    Color.backgroundColor.edgesIgnoringSafeArea(.all)
                    
                    VStack{
                        HStack{
                            Spacer()
                            
                            Button(action:{
                                self.presentationMode.wrappedValue.dismiss()
                            }){
                                Image(systemName : "xmark.circle.fill")
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        
                        Spacer().frame(height : 10)
                        
                        Text("검사 진행 중")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer().frame(height : 10)
                        
                        Text("DeepMind에서 고객님의 요청사항을 처리하고 있습니다.\n잠시 기다려 주십시오.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                            .multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        HStack{
                            if detectType == .HOUSE{
                                ProgressView()
                            } else if detectingError == .HOUSE{
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(Color.orange)
                            } else{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                            
                            Spacer().frame(width : 10)
                            
                            Text("CL01 (집) 오브젝트 검출")
                                .fontWeight(detectType == .HOUSE ? .semibold : .regular)
                                .foregroundStyle(detectType == .HOUSE ? Color.txt_color : Color.gray)
                        }
                        
                        Spacer().frame(height : 10)
                        
                        HStack{
                            if detectType == .TREE{
                                ProgressView()
                            } else if detectingError == .TREE{
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(Color.orange)
                            } else if detectType == .PERSON_1 || detectType == .PERSON_2{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                            
                            Spacer().frame(width : 10)

                            Text("CL02 (나무) 오브젝트 검출")
                                .fontWeight(detectType == .TREE ? .semibold : .regular)
                                .foregroundStyle(detectType == .TREE ? Color.txt_color : Color.gray)
                        }
                        
                        Spacer().frame(height : 10)
                        
                        HStack{
                            if detectType == .PERSON_1{
                                ProgressView()
                            } else if detectingError == .PERSON_1{
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(Color.orange)
                            } else if detectType == .PERSON_2{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            }
                            
                            Spacer().frame(width : 10)

                            Text("CL03 (첫번째 사람) 오브젝트 검출")
                                .fontWeight(detectType == .PERSON_1 ? .semibold : .regular)
                                .foregroundStyle(detectType == .PERSON_1 ? Color.txt_color : Color.gray)
                        }
                        
                        Spacer().frame(height : 10)
                        
                        HStack{
                            if isDetectComplete{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(Color.green)
                            } else if detectType == .PERSON_2{
                                ProgressView()
                            } else if detectingError == .PERSON_2{
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundStyle(Color.orange)
                            }
                            
                            Spacer().frame(width : 10)

                            Text("CL03 (두번째 사람) 오브젝트 검출")
                                .fontWeight(detectType == .PERSON_2 ? .semibold : .regular)
                                .foregroundStyle(detectType == .PERSON_2 ? Color.txt_color : Color.gray)
                        }
                        
                        Spacer()
                        
                        if isDetectComplete{
                            Text("DeepMind에서 고객님이 요청하신 작업을 모두 완료하였습니다.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                                .multilineTextAlignment(.center)
                            
                            Spacer().frame(height : 20)
                            
                            Button(action: {
                                showResult = true
                            }){
                                HStack{
                                    Text("검출 결과 확인")
                                        .foregroundColor(.white)
                                    
                                    Image(systemName : "chevron.right")
                                        .foregroundColor(.white)
                                }.padding([.vertical], 20)
                                    .padding([.horizontal], 120)
                                    .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.accent).shadow(radius: 5))
                            }
                        } else if detectingError != nil{
                            Text("DeepMind에서 고객님이 요청하신 작업을 처리하는 중 문제가 발생했습니다.\n필수 구성 요소 (예: 집 전체, 나무 전체, 사람 전체)가 인식되지 않았거나, 내부 오류일 수 있습니다. 다른 그림으로 다시 시도하거나, 나중에 다시 시도하십시오.")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                                .multilineTextAlignment(.center)
                            
                            Spacer().frame(height : 20)
                            
                            Button(action: {
                                self.presentationMode.wrappedValue.dismiss()
                            }){
                                HStack{
                                    Text("이전 화면으로 돌아가기")
                                        .foregroundColor(.white)
                                    
                                    Image(systemName : "chevron.right")
                                        .foregroundColor(.white)
                                }.padding([.vertical], 20)
                                    .padding([.horizontal], 80)
                                    .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.accent).shadow(radius: 5))
                            }
                        }
                        
                    }.padding(20)
                        .sheet(isPresented: $showResult){
                            DetectionResultsView(elapsedTimes: $elapsedTimes, docId: docId)
                        }
                        .onAppear{
                            DispatchQueue.global().async{
                                let dateFormatter = DateFormatter()
                                dateFormatter.dateFormat = "yyyy.MM.dd. HH:mm:ss"
                                
                                self.docId = dateFormatter.string(from: Date())
                                
                                let result_CL01 = helper.detect(type: .HOUSE, docId: docId)
                                
                                if result_CL01 == nil{
                                    detectType = nil
                                    detectingError = .HOUSE
                                } else{
                                    helper.saveImage(image: result_CL01!, imageName: "Detection_House.png")
                                    detectType = .TREE
                                    let result_CL02 = helper.detect(type: .TREE, docId: docId)
                                    
                                    if result_CL02 == nil{
                                        detectType = nil
                                        detectingError = .TREE
                                    } else{
                                        helper.saveImage(image: result_CL02!, imageName: "Detection_Tree.png")

                                        detectType = .PERSON_1
                                        
                                        let result_CL03_1 = helper.detect(type: .PERSON_1, docId: docId)
                                        
                                        if result_CL03_1 == nil{
                                            detectType = nil
                                            detectingError = .PERSON_1
                                        } else{
                                            helper.saveImage(image: result_CL03_1!, imageName: "Detection_Person_1.png")

                                            detectType = .PERSON_2
                                            
                                            let result_CL03_2 = helper.detect(type: .PERSON_2, docId: docId)
                                            
                                            if result_CL03_2 == nil{
                                                detectType = nil
                                                detectingError = .PERSON_2
                                            } else{
                                                helper.saveImage(image: result_CL03_2!, imageName: "Detection_Person_2.png")

                                                isDetectComplete = true
                                            }
                                        }
                                    }
                                }
                            }
 
                        }
                }.animation(.easeInOut)
            } else{
                VStack{
                    HStack{
                        Button(action: {
                            isDraw = true
                        }){
                            Image(systemName : isDraw ? "pencil.line" : "pencil")
                                .foregroundStyle(isDraw ? Color.accentColor : Color.gray)
                        }
                        
                        Spacer().frame(width : 10)
                        
                        Button(action: {
                            isDraw = false
                        }){
                            Image(systemName: !isDraw ? "eraser.line.dashed.fill" : "eraser")
                                .foregroundStyle(!isDraw ? Color.accentColor : Color.gray)
                        }
                        
                        Spacer()
                        
                        VStack{
                            Text("\(drawingType.description)\(drawingType.description == "나무" ? "를" : "을") 그려주세요.")
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
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    CanvasView(canvas: $canvasView, isDraw: $isDraw, type: $type, color: $color)
                }.padding(20)
                    .alert(isPresented: $showErrorAlert, content: {
                        return Alert(title: Text("오류"), message: Text("이미지를 저장하는 중 문제가 발생했습니다."), dismissButton: .default(Text("확인")))
                    })
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
                                    elapsedTimes.append(timer)
                                    
                                    DispatchQueue.main.async{
                                        switch drawingType{
                                        case .HOUSE:
                                            showProgress = true
                                            let result = helper.saveImage(image: canvasView.asUIImage().resized(to: CGSize(width: 1080, height : 1080)), imageName: "House.png")
                                            
                                            if result{
                                                drawingType = .TREE
                                                canvasView.drawing = PKDrawing()
                                                timer = 0
                                            } else{
                                                elapsedTimes.removeLast()
                                                showErrorAlert = true
                                            }
                                            
                                            showProgress = false
                                            
                                            
                                        case .TREE:
                                            showProgress = true
                                            let result = helper.saveImage(image: canvasView.asUIImage().resized(to: CGSize(width: 1080, height : 1080)), imageName: "Tree.png")
                                            
                                            if result{
                                                drawingType = .PERSON_1
                                                canvasView.drawing = PKDrawing()
                                                timer = 0
                                            } else{
                                                elapsedTimes.removeLast()
                                                showErrorAlert = true
                                            }
                                            
                                            showProgress = false
                                            
                                        case .PERSON_1:
                                            showProgress = true
                                            let result = helper.saveImage(image: canvasView.asUIImage().resized(to: CGSize(width: 1080, height : 1080)), imageName: "Person_1.png")
                                            
                                            if result{
                                                drawingType = .PERSON_2
                                                canvasView.drawing = PKDrawing()
                                                timer = 0
                                            } else{
                                                elapsedTimes.removeLast()
                                                showErrorAlert = true
                                            }
                                            
                                            showProgress = false
                                            
                                        case .PERSON_2:
                                            showProgress = true
                                            let result = helper.saveImage(image: canvasView.asUIImage().resized(to: CGSize(width: 1080, height : 1080)), imageName: "Person_2.png")
                                            
                                            if result{
                                                isDetecting = true
                                            } else{
                                                elapsedTimes.removeLast()
                                                showErrorAlert = true
                                            }
                                            
                                            showProgress = false
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
            }
            
            
        }.navigationViewStyle(StackNavigationViewStyle())
            .navigationBarHidden(true)
        
    }
}

#Preview {
    DrawingView()
}
