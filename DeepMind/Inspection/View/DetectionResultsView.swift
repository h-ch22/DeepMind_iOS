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
    @StateObject private var helper = InspectionHelper()
    
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
                    
                    if UIDevice.current.userInterfaceIdiom == .pad{
                        Image(uiImage: helper.getDetectedImage(type: typeList[currentIndex]) ?? UIImage())
                            .resizable()
                            .frame(width: 700, height : 700)
                    } else{
                        Image(uiImage: helper.getDetectedImage(type: typeList[currentIndex]) ?? UIImage())
                            .resizable()
                            .frame(width: 350, height : 350)
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action: {
                        showModal = true
                    }){
                        Text("필수 문답 작성하기")
                    }.padding(10).buttonStyle(.borderedProminent)
                    
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
                                
                            }
                        }){
                            Text(currentIndex == 3 ? "완료" : "다음")
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
                                                answer_Person_Second: $answer_Person_2)
            }
    }
}

#Preview {
    DetectionResultsView()
}
