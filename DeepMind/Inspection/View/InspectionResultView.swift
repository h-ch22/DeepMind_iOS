//
//  InspectionResultView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/13/23.
//

import SwiftUI

struct InspectionResultView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var helper: InspectionHelper
    @StateObject var userManagement: UserManagement
    
    @State private var currentIndex = 0
    @State private var categories = ["공통", "집", "나무", "사람"]
    @State private var titles : [String] = []
    @State private var results: [InspectionSeverityModel] = []
    
    @State private var houseTitles: [String] = []
    @State private var houseResults: [InspectionSeverityModel] = []
    
    @State private var treeTitles: [String] = []
    @State private var treeResults: [InspectionSeverityModel] = []
    
    @State private var personTitles: [String] = []
    @State private var personResults: [InspectionSeverityModel] = []
    
    @State private var showProgress = false
    @State private var showShareSheet = false
    
    @State private var showCommunityDeepLink = false
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    HStack{
                        switch currentIndex{
                        case 0:
                            if !titles.isEmpty && !results.isEmpty{
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.green)
                                
                                Text("DeepMind에서 사용자의 그림을 기반으로 HTP 검사를 완료하였습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            } else{
                                Image(systemName: "xmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.red)
                                
                                Text("DeepMind에서 검사 결과를 받아오는 중 문제가 발생했습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            }
                            
                        case 1:
                            if !houseTitles.isEmpty && !houseResults.isEmpty{
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.green)
                                
                                Text("DeepMind에서 사용자의 그림을 기반으로 HTP 검사를 완료하였습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            } else{
                                Image(systemName: "xmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.red)
                                
                                Text("DeepMind에서 검사 결과를 받아오는 중 문제가 발생했습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            }
                            
                        case 2:
                            if !treeTitles.isEmpty && !treeResults.isEmpty{
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.green)
                                
                                Text("DeepMind에서 사용자의 그림을 기반으로 HTP 검사를 완료하였습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            } else{
                                Image(systemName: "xmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.red)
                                
                                Text("DeepMind에서 검사 결과를 받아오는 중 문제가 발생했습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            }
                            
                        case 3:
                            if !personTitles.isEmpty && !personResults.isEmpty{
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.green)
                                
                                Text("DeepMind에서 사용자의 그림을 기반으로 HTP 검사를 완료하였습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            } else{
                                Image(systemName: "xmark.circle.fill")
                                    .font(.largeTitle)
                                    .foregroundStyle(Color.red)
                                
                                Text("DeepMind에서 검사 결과를 받아오는 중 문제가 발생했습니다.")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                            }
                            
                        default:
                            Image(systemName: "square.and.arrow.down.fill")
                                .font(.largeTitle)
                                .foregroundStyle(Color.accent)
                            
                            Text("검사 타입을 선택하고 검사 결과를 확인하십시오.")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt)
                        }

                        
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Divider()
                    
                    Spacer().frame(height: 10)
                    
                    Picker("", selection : $currentIndex){
                        ForEach(categories.indices, id:\.self){category in
                            Text(categories[category])
                        }
                    }.pickerStyle(.segmented)
                    
                    Spacer().frame(height: 20)
                    
                    switch currentIndex{
                    case 0:
                        ForEach(self.titles.indices, id: \.self){ index in
                            InspectionResultRow(title: self.titles[index], severity: self.results[index])
                            
                            Spacer().frame(height: 20)
                        }
                        
                    case 1:
                        ForEach(self.houseTitles.indices, id: \.self){ index in
                            InspectionResultRow(title: self.houseTitles[index], severity: self.houseResults[index])
                            
                            Spacer().frame(height: 20)
                        }
                        
                    case 2:
                        ForEach(self.treeTitles.indices, id: \.self){ index in
                            InspectionResultRow(title: self.treeTitles[index], severity: self.treeResults[index])
                            
                            Spacer().frame(height: 20)
                        }
                        
                    case 3:
                        ForEach(self.personTitles.indices, id: \.self){ index in
                            InspectionResultRow(title: self.personTitles[index], severity: self.personResults[index])
                            
                            Spacer().frame(height: 20)
                        }
                        
                    default:
                        EmptyView()
                    }
                                        
                    Text("이 검사 결과에 대한 세부적인 해석 또는 진단이 필요한 경우 검사 결과를 커뮤니티에 공유하거나, 전문가와 상담을 신청하실 수 있습니다.")
                        .foregroundStyle(Color.gray)
                        .font(.caption)
                    
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            self.showShareSheet = true
                        }){
                            Image(systemName: "square.and.arrow.up")
                            Text("PDF로 내보내기")
                        }.buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button(action: {
                            showCommunityDeepLink = true
                        }){
                            Image(systemName: "person.2.fill")
                            Text("커뮤니티에 공유")
                        }.buttonStyle(.bordered)
                        
                        Spacer()
                    }
                    
                }.padding(20)
            }.background(
                Color.background.edgesIgnoringSafeArea(.all)
            )
            .onAppear{
                if helper.commonInspectionResult != nil{
                    self.titles = helper.commonInspectionResult!.getTitle()
                    self.results = helper.commonInspectionResult!.getResults()
                }
                
                if helper.houseInspectionResult != nil{
                    self.houseTitles = helper.houseInspectionResult!.getTitle()
                    self.houseResults = helper.houseInspectionResult!.getResults()
                }
                
                if helper.treeInspectionResult != nil{
                    self.treeTitles = helper.treeInspectionResult!.getTitle()
                    self.treeResults = helper.treeInspectionResult!.getResults()
                }
                
                if helper.personInspectionResult != nil{
                    self.personTitles = helper.personInspectionResult!.getTitle()
                    self.personResults = helper.personInspectionResult!.getResults()
                }
            }
            .sheet(isPresented: $showShareSheet, content:{
                ActivityViewController(activityItems: [helper.exportAsPDF(data: helper.data!, UID: userManagement.getUID())])
            })
            .sheet(isPresented: $showCommunityDeepLink, content: {
                WriteCommunityDeepLinkView(userManagement: userManagement, entryPoint: .HTP, data: helper.data!)
            })
        }
    }
}

#Preview {
    InspectionResultView(helper: InspectionHelper(), userManagement: UserManagement())
}
