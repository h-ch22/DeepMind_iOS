//
//  DetectionResultsView.swift
//  DeepMind
//
//  Created by 하창진 on 8/10/23.
//

import SwiftUI

struct DetectionResultsView: View {
    @Environment(\.presentationMode) var presentationMode

    @State private var typeList : [DrawingTypeModel] = [.HOUSE, .TREE, .PERSON_1, .PERSON_2]
    @State private var currentIndex = 0
    @State private var showModal = false
    @State private var answer_House = HouseEssentialQuestionAnswerModel()
    @State private var answer_Tree = TreeEssentialQuestionAnswerModel()
    @State private var answer_Person_1 = PersonEssentialQuestionAnswerModel()
    @State private var answer_Person_2 = PersonEssentialQuestionAnswerModel()
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var showShareSheet = false
    @State private var showDetected = true
    @Binding var elapsedTimes: [Int]
    
    @StateObject private var helper = InspectionHelper()
    @StateObject private var userManagement = UserManagement()

    let docId: String
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    HStack{
                        Spacer()
                        
                        Text("현재 오브젝트 : \(typeList[currentIndex].description)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Text("고객님의 이미지에서 오브젝트를 검출한 결과입니다.")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)
                        .multilineTextAlignment(.center)
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        Toggle("검출된 이미지 보기", isOn: $showDetected)
                    }
                                        
                    Spacer().frame(height : 10)
                    
                    if UIDevice.current.userInterfaceIdiom == .pad{
                        Image(uiImage: (showDetected ? helper.getDetectedImage(type: typeList[currentIndex]) :
                                            helper.getImage(type: typeList[currentIndex])) ?? UIImage())
                            .resizable()
                            .frame(width: 700, height : 700)
                    } else{
                        Image(uiImage: (showDetected ? helper.getDetectedImage(type: typeList[currentIndex]) :
                                            helper.getImage(type: typeList[currentIndex])) ?? UIImage())
                            .resizable()
                            .frame(width: 350, height : 350)
                    }
                    
                    Spacer().frame(height : 20)
                    
                    if currentIndex < 3{
                        Button(action: {
                            showModal = true
                        }){
                            Text("필수 문답 작성하기")
                        }.padding(10).buttonStyle(.borderedProminent)
                    } else{
                        HStack{
                            Button(action: {
                                showModal = true
                            }){
                                Text("필수 문답 작성하기")
                            }.padding(10).buttonStyle(.borderedProminent)
                            
                            Spacer()
                            
                            if self.showShareSheet{
                                ProgressView()
                            } else{
                                Button(action:{
                                    self.showShareSheet = true
                                }){
                                    HStack{
                                        Image(systemName: "square.and.arrow.up")
                                        Text("PDF 내보내기")
                                    }
                                }.padding(10).buttonStyle(.bordered)
                            }
                        }
                        
                        Spacer().frame(height : 5)
                        
                        Text("심리상태에 문제가 있다고 판단되는 경우 이 검출 결과를 PDF로 내보내어 의료기관에 참고자료로 이용할 수 있습니다.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }

                    Spacer()
                    
                                        
                    HStack{
                        Button(action: {
                            if currentIndex > 0{
                                currentIndex -= 1
                            }
                        }){
                            Text("이전")
                        }.padding(10).buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button(action: {
                            if currentIndex < 3{
                                currentIndex += 1
                            } else{
                                showProgress = true
                                helper.uploadEssentialQuestionAnswer(answer_House: answer_House, answer_Tree: answer_Tree, answer_Person_1: answer_Person_1, answer_Person_2: answer_Person_2, docId: docId){result in
                                    guard let result = result else{return}
                                    
                                    showProgress = false
                                    
                                    if result{
                                        self.presentationMode.wrappedValue.dismiss()
                                    }
                                }
                            }
                        }){
                            if !showProgress{
                                Text(currentIndex == 3 ? "완료" : "다음")
                            } else{
                                ProgressView()
                            }
                        }.padding(10).buttonStyle(.bordered)
                    }
                }.padding(20)
            }
        }.navigationTitle(Text("오브젝트 검출 결과"))
            .toolbar{
                ToolbarItemGroup(placement: .topBarTrailing, content: {
                    Button(action:{
                        self.presentationMode.wrappedValue.dismiss()
                    }){
                        Text("닫기")
                    }
                })
            }
            .navigationViewStyle(StackNavigationViewStyle())
            .sheet(isPresented: $showModal){
                InspectionEssentialQuestionView(type: typeList[currentIndex],
                                                answer_House: $answer_House,
                                                answer_Tree: $answer_Tree,
                                                answer_Person_First: $answer_Person_1,
                                                answer_Person_Second: $answer_Person_2,
                                                img: helper.getImage(type: typeList[currentIndex]))
            }
            .alert(isPresented: $showAlert){
                return Alert(title: Text("오류"), message: Text("결과를 서버에 업로드하는 중 문제가 발생하였습니다.\n나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
            }
            .sheet(isPresented: $showShareSheet, content:{
                ActivityViewController(activityItems: [helper.exportAsPDF(data: helper.createPDF(answer_House: answer_House,
                                                                                                 answer_Tree: answer_Tree,
                                                                                                 answer_Person_1: answer_Person_1,
                                                                                                 answer_Person_2: answer_Person_2,
                                                                                                 img_House: helper.getImage(type: DrawingTypeModel.HOUSE) ?? UIImage(),
                                                                                                 img_Tree: helper.getImage(type: DrawingTypeModel.TREE) ?? UIImage(),
                                                                                                 img_Person_1: helper.getImage(type: DrawingTypeModel.PERSON_1) ?? UIImage(),
                                                                                                 img_Person_2: helper.getImage(type: DrawingTypeModel.PERSON_2) ?? UIImage(),
                                                                                                 img_House_Detected: helper.getDetectedImage(type: DrawingTypeModel.HOUSE) ?? UIImage(),
                                                                                                 img_Tree_Detected: helper.getDetectedImage(type: DrawingTypeModel.TREE) ?? UIImage(),
                                                                                                 img_Person_1_Detected: helper.getDetectedImage(type: DrawingTypeModel.PERSON_1) ?? UIImage(),
                                                                                                 img_Person_2_Detected: helper.getDetectedImage(type: DrawingTypeModel.PERSON_2) ?? UIImage(),
                                                                                                 UID: userManagement.getUID(),
                                                                                                 date: nil,
                                                                                                 elapsedTimes: elapsedTimes), UID: userManagement.getUID())])
            })
    }
}
