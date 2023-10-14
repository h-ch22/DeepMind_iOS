//
//  HomeView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var inspectionHelper = InspectionHelper()
    @StateObject private var communityHelper = CommunityHelper()
    @StateObject private var healthKitHelper = HealthDataHelper()
    @StateObject var userManagement: UserManagement

    @State private var currentIndex = 0
    @State private var showDailyEmotionView = false
    @State private var showArticle = false
    @State private var selectedArticle: CommunityArticleDataModel? = nil
    
    let parent: TabManager
    let columns = [
        GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .phone ? 60 : 190))
    ]
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.accentColor, Color.backgroundColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    HStack{
                        Text("안녕하세요,\n\(AES256Util.decrypt(encoded: userManagement.userInfo?.name ?? ""))님😆")
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action:{}){
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "pencil.and.scribble")
                                    .foregroundStyle(Color.accentColor)
                                
                                Text("HTP 검사")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.accentColor)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Text(inspectionHelper.latestInspectionResult ?? "최근 검사 기록 없음")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                            }
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Button(action:{}){
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "flame.fill")
                                    .foregroundStyle(Color.orange)
                                
                                Text("걷기 및 달리기 거리")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.orange)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Text("\(String(format: "%.2f", healthKitHelper.excerciseDistance)) m")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                            }
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Button(action:{
                        self.showDailyEmotionView = true
                    }){
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "heart.fill")
                                    .foregroundStyle(Color.red)
                                
                                Text("하루 감정")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.red)
                                
                                Spacer()
                                
                                Text(healthKitHelper.dailyEmotionTime ?? "")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Text("\(DiaryHelper.convertEmotionCodeToString(code: healthKitHelper.dailyEmotion) ?? "데이터 없음")")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                            }
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height: 10)
                    
                    Button(action:{}){
                        VStack(alignment: .leading){
                            HStack{
                                Image(systemName: "sun.max.fill")
                                    .foregroundStyle(Color.blue)
                                
                                Text("일광 시간")
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.blue)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Text("\(String(format: "%d", Int(healthKitHelper.dayLightTime))) 분")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                            }
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                    }
                    
                    Spacer().frame(height: 20)
                    
                    if userManagement.userInfo?.type == .PROFESSIONAL{
                        HStack{
                            Text("상담 관리")
                                .foregroundStyle(Color.txt_color)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 20)

                        HStack{
                            Button(action: {}){
                                HStack{
                                    Text("더 많은 상담 관리하기")
                                        .foregroundStyle(Color.txt_color)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundStyle(Color.txt_color)
                                }.padding(20)
                                    .frame(minHeight: 80, maxHeight: 80)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                            }
                        }
                    } else{
                        HStack{
                            Text("🔥 최신 커뮤니티 게시물")
                                .foregroundStyle(Color.txt_color)
                                .fontWeight(.semibold)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 20)
                        
                        HStack{
                            ForEach(communityHelper.latestArticles, id:\.self){item in
                                Button(action: {
                                    self.selectedArticle = item
                                    showArticle = true
                                }){
                                    HomeCommunityListModel(data: item)
                                }
                                
                                Spacer().frame(width: 10)
                            }
                            
                            Button(action: {
                                parent.changeView(index: 3)
                            }){
                                HStack{
                                    Text("더 많은 게시물 확인하기")
                                        .foregroundStyle(Color.txt_color)
                                        .fontWeight(.semibold)
                                    
                                    Image(systemName: "arrow.right.circle.fill")
                                        .foregroundStyle(Color.txt_color)
                                }.padding(20)
                                    .frame(minHeight: 80, maxHeight: 80)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                            }
                            
                            Spacer()
                        }
                    }
                    
                }.padding(20)
                    .onAppear{
                        healthKitHelper.requestAuthorization(){ result in
                            guard let result = result else{return}
                            
                            if result{
                                healthKitHelper.updateData()
                            }
                        }
                        
                        communityHelper.getLatestArticles(){ _ in }
                        
                        inspectionHelper.getLatestHistory(){_ in }
                    }
                    .navigationBarHidden(true)
                    .animation(.easeInOut)
                    .sheet(isPresented: $showDailyEmotionView){
                        AddDailyEmotionView()
                    }
                    .sheet(isPresented: Binding(
                        get: {showArticle},
                        set: {showArticle = $0}
                    ), content: {
                        if selectedArticle != nil{
                            CommunityDetailView(userManagement: userManagement, helper: communityHelper, data: selectedArticle!)
                        }
                    })
            }
        }
    }
}

#Preview {
    Group{
        HomeView(userManagement: UserManagement(), parent: TabManager(userManagement: UserManagement()))
    }
}
