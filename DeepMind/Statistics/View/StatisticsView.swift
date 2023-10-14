//
//  StatisticsView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var inspectionHelper = InspectionHelper()
    @StateObject private var healthDataHelper = HealthDataHelper()
    @StateObject private var diaryHelper = DiaryHelper()
    
    @State private var currentIndex = 0
    @State private var categories = ["HTP 검사", "성장일기 감정", "하루감정"]
    @State private var showProgress = true
    @State private var showURLProgress = false
    @State private var showPDFViewer = false

    var body: some View {
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
                        if inspectionHelper.inspectionResults.isEmpty{
                            Text("HTP 검사를 진행하고 통계를 확인해보세요.")
                                .foregroundStyle(Color.gray)
                        } else{
                            ScrollView{
                                LazyVStack{
                                    ForEach(inspectionHelper.inspectionResults, id: \.self){ result in
                                        Button(action: {
                                            showURLProgress = true
                                            
                                            inspectionHelper.getFileURL(id: result){ result in
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
                    if currentIndex == 1 && diaryHelper.emotionList.isEmpty{
                        Text("데이터 없음")
                    } else if currentIndex == 2 && healthDataHelper.emotionList.isEmpty{
                        Text("데이터 없음")
                    } else{
                        ScrollView{
                            Chart{
                                ForEach(currentIndex == 2 ? healthDataHelper.emotionList : diaryHelper.emotionList){emotion in
                                    BarMark(x: .value("감정", emotion.emotion),
                                            y:.value("통계", emotion.count))
                                }
                            }
                            
                            LazyVStack{
                                ForEach(Array(currentIndex == 2 ? healthDataHelper.emotionStack.keys : diaryHelper.emotionStack.keys), id: \.self){data in
                                    HStack{
                                        Text(data)
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt)
                                        
                                        Spacer()

                                        Text(currentIndex == 2 ? healthDataHelper.emotionStack[data] ?? "데이터 없음" : diaryHelper.emotionStack[data] ?? "데이터 없음")
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
                    inspectionHelper.getInspectionHistory(){result in
                        guard let result = result else{return}
                        
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
                        inspectionHelper.getInspectionHistory(){result in
                            guard let result = result else{return}
                            
                            showProgress = false
                        }
                        
                    case 1:
                        diaryHelper.getEmotionList(){result in
                            guard let result = result else{return}
                            
                            showProgress = false
                        }
                        
                    case 2:
                        healthDataHelper.getDailyEmotionList(){result in
                            guard let result = result else{return}
                            
                            showProgress = false
                        }
                        
                    default:
                        break
                    }
                }
        }
    }
}

#Preview {
    StatisticsView()
}
