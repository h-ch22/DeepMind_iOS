//
//  MoreView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct MoreView: View {
    @StateObject var helper : UserManagement
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        HStack{
                            Text("Deep")
                                .font(.title2)
                                .foregroundStyle(Color.txt_color)
                            
                            Text("Mind")
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt_color)
                            
                            Spacer()
                        }
                        
                        NavigationLink(destination: UserInfoView(helper: helper)){
                            HStack{
                                Image("ic_appstore")
                                    .resizable()
                                    .frame(width : 35, height : 35)
                                    .clipShape(Circle())
                                
                                VStack(alignment : .leading){
                                    HStack{
                                        Text(AES256Util.decrypt(encoded: helper.userInfo?.name ?? ""))
                                            .foregroundColor(.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        ProBadgeView()
                                            .isHidden(helper.userInfo?.type != .PROFESSIONAL)
                                    }
                                    
                                    Text(AES256Util.decrypt(encoded: helper.userInfo?.email ?? ""))
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                            }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        Divider()
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination : StatisticsView().navigationTitle(Text("통계 및 검사 기록"))){
                            HStack{
                                Image(systemName: "chart.xyaxis.line")
                                
                                VStack(alignment : .leading){
                                    Text("통계 및 검사 기록")
                                        .foregroundColor(.txt_color)
                                }
                                
                                Spacer()
                            }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination : DiaryView().navigationTitle(Text("성장 일기"))){
                            HStack{
                                Image(systemName: "square.and.pencil")
                                
                                VStack(alignment : .leading){
                                    Text("성장 일기")
                                        .foregroundColor(.txt_color)
                                }
                                
                                Spacer()
                            }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)
                        
                        NavigationLink(destination : EmptyView()){
                            HStack{
                                Image(systemName: "calendar.badge.clock")
                                
                                VStack(alignment : .leading){
                                    Text("병원 예약 기록")
                                        .foregroundColor(.txt_color)
                                }
                                
                                Spacer()
                            }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                        
                        Spacer().frame(height : 20)

                        NavigationLink(destination : InfoView()){
                            HStack{
                                Image(systemName: "info.circle.fill")
                                
                                VStack(alignment : .leading){
                                    Text("정보")
                                        .foregroundColor(.txt_color)
                                }
                                
                                Spacer()
                            }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                        }
                    }
                    
                }.padding(20)
                    .animation(.easeInOut, value: 1.0)
            }
        }
        
    }
}

#Preview {
    MoreView(helper: UserManagement())
}
