//
//  ConsultingLogView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI

struct ConsultingLogView: View {
    @StateObject var helper: ConsultingHelper
    @StateObject var userManagement: UserManagement
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                LazyVStack{
                    ForEach(helper.allReservationList, id: \.self){item in
                        NavigationLink(destination: ConsultingDetailView(helper: helper, userManagement: userManagement, data: item, isDone: helper.reservationList.contains(item) ? false : true, isUnRated: helper.unratedReservationList.contains(item) ? true : false, isModal: false)){
                            HStack{
                                if item.mentorProfile != nil{
                                    AsyncImage(url: item.mentorProfile!, content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 40, height: 40)
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                } else{
                                    Image("ic_appstore")
                                        .resizable()
                                        .frame(width : 40, height : 40)
                                        .clipShape(Circle())
                                        .shadow(radius: 5)
                                }
                                
                                Spacer().frame(width: 10)
                                
                                VStack{
                                    HStack{
                                        Text("\(item.date) \(item.time)")
                                            .foregroundStyle(Color.accentColor)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer().frame(height: 5)

                                    HStack{
                                        Text(item.mentorName)
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                        
                                        Spacer()
                                        
                                        Text("\(item.type == .INTERVIEW ? "방문 상담" : "채팅 상담")")
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                    }
                                }
                            }.padding(20)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn).shadow(radius: 5))
                        }
                    }
                }.padding(20)
                    .navigationTitle(Text("상담 기록"))
            }.background(
                Color.background.edgesIgnoringSafeArea(.all)
            )
        }
    }
}
