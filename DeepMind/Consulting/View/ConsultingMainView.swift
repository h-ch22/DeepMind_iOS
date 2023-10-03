//
//  ConsultingMainView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import SwiftUI

struct ConsultingMainView: View {
    @State private var showProgress = true
    @State private var showReservationSheet = false
    @State private var selectedMentor: MentorInfoModel? = nil
    @State private var selectedData: ConsultingDataModel? = nil
    @State private var showDetailView = false
    @State private var isDone = false
    @State private var isUnRated = false
    
    @StateObject private var helper = ConsultingHelper()
    @StateObject var userManagement: UserManagement
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.5), Color.backgroundColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            if showProgress{
                VStack{
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }.padding(20)
            } else{
                ScrollView{
                    VStack{
                        if !helper.reservationList.isEmpty{
                            Button(action: {
                                selectedData = helper.reservationList[0]
                                isDone = false
                                isUnRated = false
                                showDetailView = true
                            }){
                                HStack{
                                    if helper.reservationList[0].mentorProfile != nil{
                                        AsyncImage(url: helper.reservationList[0].mentorProfile!, content: { image in
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
                                            Image(systemName: "bell.badge")
                                                .foregroundStyle(Color.red)
                                            
                                            Text("예정된 상담")
                                                .foregroundStyle(Color.txt_color)
                                                .fontWeight(.semibold)
                                            
                                            Spacer()
                                        }
                                        
                                        Spacer().frame(height: 5)
                                        
                                        HStack{
                                            Text("\(helper.reservationList[0].date) \(helper.reservationList[0].time)")
                                                .foregroundStyle(Color.accentColor)
                                            
                                            Spacer()
                                        }
                                        
                                        Spacer().frame(height: 5)

                                        HStack{
                                            Text(helper.reservationList[0].mentorName)
                                                .font(.caption)
                                                .foregroundStyle(Color.gray)
                                            
                                            Spacer()
                                            
                                            Text("\(helper.reservationList[0].type == .INTERVIEW ? "방문 상담" : "채팅 상담")")
                                                .font(.caption)
                                                .foregroundStyle(Color.gray)
                                        }
                                    }
                                }.padding(20)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn).shadow(radius: 5))
                            }

                            
                            Spacer().frame(height: 10)
                        }
                        
                        HStack{
                            Text("상담 예약하기")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt)
                            
                            Spacer()
                        }
                        
                        Spacer().frame(height: 10)
                        
                        ScrollView(.horizontal){
                            LazyHStack{
                                ForEach(helper.mentors, id: \.self){mentor in
                                    Button(action: {
                                        selectedMentor = mentor
                                        
                                        if selectedMentor != nil{
                                            showReservationSheet = true
                                        }
                                    }){
                                        ConsultingMentorListModel(data: mentor)
                                    }
                                    
                                    Spacer().frame(width: 10)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        Spacer().frame(height: 20)

                        if !helper.unratedReservationList.isEmpty{
                            Spacer().frame(height: 10)

                            HStack{
                                Text("지난 상담은 어떠셨나요?")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            TabView{
                                ForEach(helper.unratedReservationList, id:\.self){ item in
                                    Button(action:{
                                        selectedData = item
                                        isDone = true
                                        isUnRated = true
                                        showDetailView = true
                                    }){
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
                                                    Image(systemName: "clock.badge.checkmark")
                                                        .foregroundStyle(Color.accentColor)
                                                    
                                                    Text("지난 상담")
                                                        .foregroundStyle(Color.txt_color)
                                                        .fontWeight(.semibold)
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer().frame(height: 5)
                                                
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
                            }.frame(height: 120)
                            .tabViewStyle(.page)
                        }
                        
                    }.padding(20)
                }.background(
                    LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.5), Color.backgroundColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                )
            }
        }
        .toolbar{
            ToolbarItemGroup(placement: .topBarTrailing, content: {
                Button(action: {}){
                    Image(systemName: "clock.arrow.circlepath")
                        .foregroundStyle(Color.txt_color)
                }
            })
        }
        .onAppear{
            helper.getAllMentors(){ result in
                guard let result = result else{return}
                
                showProgress = false
            }
            
            helper.getReservationList(uid: userManagement.userInfo?.UID ?? ""){ result in
                guard let result = result else{return}
            }
        }
        .sheet(isPresented: Binding(
            get: {showReservationSheet},
            set: {showReservationSheet = $0}
        ), content: {
            if selectedMentor != nil{
                ConsultingReservationView(helper: helper, userManagement: userManagement, data: selectedMentor!)
            }
        })
        .sheet(isPresented: Binding(
            get: {showDetailView},
            set: {showDetailView = $0}
        ), content: {
            if selectedData != nil{
                ConsultingDetailView(helper: helper, data: selectedData!, isDone: isDone, isUnRated: isUnRated)
            }
        })
    }
}

#Preview {
    ConsultingMainView(userManagement: UserManagement())
}
