//
//  HomeEmotionStatisticsView.swift
//  DeepMind
//
//  Created by 하창진 on 8/16/23.
//

import SwiftUI

struct HomeEmotionStatisticsView: View {
    let type : HomeStatisticsTypeModel
    @StateObject var helper : DailyEmotionHelper
    
    var body: some View {
        VStack{
            HStack(spacing: 20){
                ForEach(UIDevice.current.userInterfaceIdiom == .phone ? 0..<2 : 0..<4, id:\.self){item in
                    VStack{
                        Text(helper.diaryEmotionStatistics[item].emotion)
                                                
                        Spacer().frame(height : 10)
                        
                        Text(String(type == .DIARY_EMOTION ? helper.diaryEmotionStatistics[item].count : helper.dailyEmotionStatistics[item].count))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accent)
                    }
                        .frame(width : 150, height : 80)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                }
            }
            
            Spacer().frame(height : UIDevice.current.userInterfaceIdiom == .phone ? 10 : 20)
            
            HStack(spacing: 20){
                ForEach(UIDevice.current.userInterfaceIdiom == .phone ? 2..<4 : 4..<8, id: \.self){item in
                    VStack{
                        Text(helper.diaryEmotionStatistics[item].emotion)

                        Spacer().frame(height : 10)

                        Text(String(type == .DIARY_EMOTION ? helper.diaryEmotionStatistics[item].count : helper.dailyEmotionStatistics[item].count))
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.accent)
                    }.frame(width : 150, height : 80)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                }
            }
            
            if UIDevice.current.userInterfaceIdiom == .phone{
                Spacer().frame(height : 10)

                HStack(spacing: 20){
                    ForEach(4..<6, id: \.self){item in
                        VStack{
                            Text(helper.diaryEmotionStatistics[item].emotion)

                            Spacer().frame(height : 10)

                            Text(String(type == .DIARY_EMOTION ? helper.diaryEmotionStatistics[item].count : helper.dailyEmotionStatistics[item].count))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accent)
                        }.frame(width : 150, height : 80)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                    }
                }
                
                Spacer().frame(height : 10)

                HStack(spacing: 20){
                    ForEach(6..<8, id: \.self){item in
                        VStack{
                            Text(helper.diaryEmotionStatistics[item].emotion)

                            Spacer().frame(height : 10)

                            Text(String(type == .DIARY_EMOTION ? helper.diaryEmotionStatistics[item].count : helper.dailyEmotionStatistics[item].count))
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accent)
                        }.frame(width : 150, height : 80)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                    }
                }
            }
        }
    }
}
