//
//  ProStatisticsView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/14/23.
//

import SwiftUI
import Charts

struct ProStatisticsView: View {
    let uid: String
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var inspectionHelper = InspectionHelper()
    @StateObject private var healthDataHelper = HealthDataHelper()
    @StateObject private var diaryHelper = DiaryHelper()
    
    @State private var currentIndex = 0
    @State private var categories = ["HTP 검사", "성장일기 감정", "하루감정"]
    @State private var showProgress = true
    @State private var showURLProgress = false
    @State private var showPDFViewer = false
    
    @State private var emotionList: [StatisticsEmotionDataModel] = []
    @State private var emotionStack: [String:String] = [:]
    
    @State private var diaryEmotionList: [StatisticsEmotionDataModel] = []
    @State private var diaryEmotionStack: [String:String] = [:]
    
    @State private var HTPResults: [String] = []
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Picker("", selection : $currentIndex){
                        ForEach(categories.indices, id:\.self){category in
                            Text(categories[category])
                        }
                    }.pickerStyle(.segmented)
                    
                    Spacer().frame(height : 20)
                    
                    switch currentIndex{
                    case 0:
                        if showProgress{
                            ProgressView()
                        } else{
                            if HTPResults.isEmpty{
                                Text("HTP 검사를 진행하고 통계를 확인해보세요.")
                                    .foregroundStyle(Color.gray)
                            } else{
                                ScrollView{
                                    LazyVStack{
                                        ForEach(HTPResults, id: \.self){ result in
                                            Button(action: {
                                                showURLProgress = true
                                                
                                                inspectionHelper.getFileURL(uid: uid, id: result){ result in
                                                    guard let result = result else{return}
                                                    
                                                    showURLProgress = false
                                                    
                                                    if result && inspectionHelper.fileURL != nil{
                                                        showPDFViewer = true
                                                    }
                                                }
                                            }){
                                                HStack{
                                                    Text(result)
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(Color.txt)
                                                    
                                                    Spacer()
                                                    
                                                    if showURLProgress{
                                                        ProgressView()
                                                    }
                                                }.padding(20)
                                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                                                
                                                Spacer().frame(height: 10)
                                            }
                                        }
                                    }
                                }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                            }
                        }
                        
                    case 1, 2:
                        if currentIndex == 1 && diaryEmotionList.isEmpty && diaryEmotionStack.isEmpty{
                            Text("데이터 없음")
                        } else if currentIndex == 2 && emotionList.isEmpty && emotionStack.isEmpty{
                            Text("데이터 없음")
                        } else{
                            ScrollView{
                                Chart{
                                    ForEach(currentIndex == 2 ? emotionList : diaryEmotionList){emotion in
                                        BarMark(x: .value("감정", emotion.emotion),
                                                y:.value("통계", emotion.count))
                                    }
                                }
                                
                                LazyVStack{
                                    ForEach(Array(currentIndex == 2 ? emotionStack.keys : diaryEmotionStack.keys), id: \.self){data in
                                        HStack{
                                            Text(data)
                                                .fontWeight(.semibold)
                                                .foregroundStyle(Color.txt)
                                            
                                            Spacer()

                                            Text(currentIndex == 2 ? emotionStack[data] ?? "데이터 없음" : diaryEmotionStack[data] ?? "데이터 없음")
                                                .foregroundStyle(Color.txt)
                                        }.padding(20)
                                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                                        
                                        Spacer().frame(height: 10)
                                    }
                                }
                            }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                        }

                        
                    default:
                        EmptyView()
                    }
                    
                    Spacer()
                }.padding(20)
                    .onAppear{
                        inspectionHelper.getInspectionHistory(uid: uid){result in
                            guard let result = result else{return}
                            
                            HTPResults = result
                            showProgress = false
                        }
                        
                    }
                    .sheet(isPresented: $showPDFViewer){
                        PDFViewer(url: inspectionHelper.fileURL!)
                    }
                    .onChange(of: currentIndex){
                        showProgress = true
                        
                        switch currentIndex{
                        case 0:
                            inspectionHelper.getInspectionHistory(uid: uid){result in
                                guard let result = result else{return}
                                
                                showProgress = false
                                
                                self.HTPResults = result
                            }
                            
                        case 1:
                            diaryHelper.getEmotionList(uid: uid){result in
                                guard let result = result else{return}
                                
                                self.diaryEmotionList = result
                            }
                            
                            diaryHelper.getEmotionStack(uid: uid){ result in
                                guard let result = result else{return}
                                
                                self.diaryEmotionStack = result
                                
                                showProgress = false
                            }
                            
                        case 2:
                            healthDataHelper.getEmotionList(uid: uid){result in
                                guard let result = result else{return}
                                
                                self.emotionList = result
                            }
                            
                            healthDataHelper.getEmotionStack(uid: uid){ result in
                                guard let result = result else{return}
                                
                                self.emotionStack = result
                                
                                showProgress = false
                            }
                            
                        default:
                            break
                        }
                    }
            }.toolbar{
                ToolbarItemGroup(placement: .topBarLeading, content: {
                    Button("닫기"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            }
            .navigationBarTitle("환자 검사 데이터")
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(StackNavigationViewStyle())

    }
}
