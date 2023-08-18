//
//  HomeView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var helper = DailyEmotionHelper()
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
                        
                        if dailyEmotion != nil{
                            Text("오늘은 \n\(emotions[dailyEmotion!.code])")
                                .multilineTextAlignment(.trailing)
                        } else{
                            Text("오늘의 감정을 기록해주세요.")
                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    if dailyEmotion == nil{
                        LazyVGrid(columns: columns, spacing: 20){
                            ForEach(emotions.indices, id:\.self){i in
                                Button(action: {
                                    helper.uploadDailyEmotion(emotion: DiaryHelper.indexToEmotion(index: i) ?? .HAPPY){ result in
                                        guard let result = result else{return}
                                    }
                                    
                                    helper.getDailyEmotion(){ result in
                                        guard let result = result else{return}
                                        
                                        self.dailyEmotion = result
                                    }
                                }){
                                    VStack{
                                        Text(emotions[i].split(separator: " ")[0])
                                            .font(UIDevice.current.userInterfaceIdiom == .phone ? .caption : .headline)
                                        Text(emotions[i].split(separator: " ")[1])
                                            .font(UIDevice.current.userInterfaceIdiom == .phone ? .caption : .headline)
                                    }
                                    .foregroundStyle(Color.txt_color)

                                }.frame(width : UIDevice.current.userInterfaceIdiom == .phone ? 60 : 120,
                                        height : UIDevice.current.userInterfaceIdiom == .phone ? 60 : 120)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                            }
                        }.padding(.horizontal)
                        
                        Spacer().frame(height : 20)
                    }
                    
                    Spacer().frame(height : 10)
                    
                    Picker("", selection : $currentIndex){
                        ForEach(categories.indices, id:\.self){category in
                            Text(categories[category])
                        }
                    }.pickerStyle(.segmented)
                    
                    Spacer().frame(height : 20)
                    
                    if currentIndex != 0{
                        HomeEmotionStatisticsView(type: currentIndex == 1 ? .DIARY_EMOTION : .DAILY_EMOTION, helper: helper)
                        
                        Spacer().frame(height : 20)

                        Button(action:{
                            parent.changeView(index: 3)
                        }){
                            HStack{
                                Image(systemName : "chart.xyaxis.line")
                                    .foregroundStyle(Color.txt_color)
                                Text("통계에서 자세한 기록 확인하기")
                                    .foregroundStyle(Color.txt_color)
                            }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                        }
                    } else{
                        Text("HTP 검사를 진행하고 통계를 확인해보세요.")
                            .foregroundStyle(Color.gray)
                        
                        Spacer().frame(height : 10)
                        
                        Button(action: {
                            parent.showInspectionSheet()
                        }){
                            Text("검사 시작")
                        }
                    }
                    
                }.padding(20)
                    .onAppear{
                        helper.getDailyEmotion(){ result in
                            guard let result = result else{return}
                            
                            self.dailyEmotion = result
                        }
                        
                        helper.getAllEmotions(){ result in
                            guard let result = result else{return}
                        }
                    }
                    .navigationBarHidden(true)
                    .animation(.easeInOut)
            }
        }
    }
}

//#Preview {
//    Group{
//        HomeView(userManagement: UserManagement(), parent: TabManager(userManagement: UserManagement()))
//    }
//}
