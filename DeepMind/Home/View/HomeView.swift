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
    @StateObject var userManagement: UserManagement
    @State private var emotions = ["🥰 행복해요", "😆 최고예요", "😀 좋아요", "🙂 그저그래요", "☹️ 안좋아요", "😢 슬퍼요", "😣 혼자있고싶어요", "😡 화나요"]
    @State private var dailyEmotion: DiaryEmotionModel? = nil
    @State private var categories = ["HTP 검사", "하루일기", "하루감정"]
    @State private var currentIndex = 0
    
    let parent: TabManager
    let columns = [
        GridItem(.adaptive(minimum: UIDevice.current.userInterfaceIdiom == .phone ? 60 : 190))
    ]
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    HStack{
                        Text("안녕하세요,\n\(AES256Util.decrypt(encoded: userManagement.userInfo?.name ?? ""))님😆")
                            .fontWeight(.semibold)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        if inspectionHelper.latestInspectionResult == nil{
                            Button(action: {}){
                                VStack{
                                    Text("최근 검사 기록이 없어요😢")
                                        .foregroundStyle(Color.white)
                                        .fixedSize(horizontal: false, vertical: /*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                                }.padding(20)
                                    .padding([.vertical], 50)
                                    .frame(width: 150, height: 150)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.gray).shadow(radius: 5))
                            }
                        }

                        
                        Button(action: {}){
                            VStack(alignment: .leading){
                                Text("HTP 검사")
                                    .font(.caption)
                                    .foregroundStyle(Color.white)
                                
                                HStack{
                                    Text("시작하기")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.white)
                                    
                                    Image(systemName : "arrow.right.circle.fill")
                                        .foregroundStyle(Color.white)
                                }
                            }.padding(20)
                                .padding([.vertical], 50)
                                .frame(width: 150, height: 150)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.accent).shadow(radius: 5))
                        }
                    }.fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                    
                    Spacer().frame(height: 20)
                    
                    if userManagement.userInfo?.type == .PROFESSIONAL{
                        
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
                                Button(action: {}){
                                    HomeCommunityListModel(data: item)
                                }
                                
                                Spacer().frame(width: 10)
                            }
                            
                            Button(action: {}){
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
//                        inspectionHelper.getLatestHistory(){ result in
//                            guard let result = result else{return}
//                        }
//                        
//                        communityHelper.getLatestArticles(){ result in
//                            guard let result = result else{return}
//                        }
                    }
                    .navigationBarHidden(true)
                    .animation(.easeInOut)
            }
        }
    }
}

#Preview {
    Group{
        HomeView(userManagement: UserManagement(), parent: TabManager(userManagement: UserManagement()))
    }
}
