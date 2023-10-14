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
                
                if currentIndex != 0{
                    
                } else{
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
        }
    }
}

#Preview {
    StatisticsView()
}
