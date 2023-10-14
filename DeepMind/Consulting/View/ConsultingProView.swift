//
//  ConsultingProView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import SwiftUI

struct ConsultingProView: View {
    @State private var showRegisterHospitalView = false
    @State private var showProgress = true
    @State private var selectedData: ConsultingDataModel? = nil
    @State private var showDetailView = false
    @State private var isDone = false
    @State private var isUnRated = false
    
    @StateObject var userManagement: UserManagement
    @StateObject private var helper = ConsultingHelper()
    
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.5), Color.backgroundColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    if helper.mentorInfo?.mentorProfile != nil{
                        AsyncImage(url: helper.mentorInfo?.mentorProfile!, content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }, placeholder: {
                            ProgressView()
                        })
                    } else{
                        Image("ic_appstore")
                            .resizable()
                            .frame(width : 80, height : 80)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    Spacer().frame(height: 20)
                    
                    Text(helper.mentorInfo?.mentorName ?? "")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)
                    
                    Spacer().frame(height: 10)

                    ProBadgeView()
                    
                    Spacer().frame(height: 20)
                    
                    HStack{
                        Text("상담 관리")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer()
                    }
                                        
                    if showProgress{
                        ProgressView()
                    } else{
                        if !helper.reservationList.isEmpty{
                            LazyVStack{
                                ForEach(helper.reservationList, id: \.self){reserve in
                                    Button(action: {
                                        selectedData = reserve
                                        isDone = false
                                        isUnRated = false
                                        showDetailView = true
                                    }){
                                        HStack{
                                            if reserve.mentorProfile != nil{
                                                AsyncImage(url: reserve.mentorProfile!, content: { image in
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
                                                    Text("\(reserve.date) \(reserve.time)")
                                                        .foregroundStyle(Color.accentColor)
                                                    
                                                    Spacer()
                                                }
                                                
                                                Spacer().frame(height: 5)

                                                HStack{
                                                    Text(AES256Util.decrypt(encoded: reserve.menteeName))
                                                        .font(.caption)
                                                        .foregroundStyle(Color.gray)
                                                    
                                                    Spacer()
                                                    
                                                    Text("\(reserve.type == .INTERVIEW ? "방문 상담" : "채팅 상담")")
                                                        .font(.caption)
                                                        .foregroundStyle(Color.gray)
                                                }
                                            }
                                        }.padding(20)
                                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn).shadow(radius: 5))
                                    }
                                }
                            }

                        } else{
                            Text("접수된 상담이 없습니다.")
                                .foregroundStyle(Color.gray)
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
                                                Text(AES256Util.decrypt(encoded: item.menteeName))
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
                    
                    Spacer().frame(height: 20)

                    HStack{
                        Text("병원 정보")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer()
                    }
                    
                    if helper.mentorInfo?.hospitalAddress == nil ||
                        helper.mentorInfo?.hospitalLocation == nil{
                        HStack{
                            Text("등록된 정보 없음")
                            
                            Spacer()
                            
                            Button(action: {
                                showRegisterHospitalView = true
                            }){
                                Text("병원 정보 등록")
                            }
                        }.padding()
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color))
                    } else{
                        ConsultingHospitalMapView(location: (helper.mentorInfo?.hospitalLocation)!,
                                                  hospitalAddress: helper.mentorInfo?.hospitalAddress ?? "")
                    }
                }.padding(20)
                    .onAppear{
                        helper.getMentorInfo(uid: userManagement.userInfo?.UID ?? ""){ result in
                            guard let result = result else{return}
                        }
                        
                        helper.getReservationList(){ result in
                            guard let result = result else{return}
                            
                            showProgress = false
                        }
                    }
                    .sheet(isPresented: $showRegisterHospitalView, content: {
                        ConsultingHospitalSelectionView(helper: helper, userManagement: userManagement)
                    })
                    .sheet(isPresented: Binding(
                        get: {showDetailView},
                        set: {showDetailView = $0}
                    ), content: {
                        if selectedData != nil{
                            ConsultingDetailView(helper: helper, userManagement: userManagement, data: selectedData!, isDone: isDone, isUnRated: isUnRated, isModal: true)
                        }
                    })
            }.background(
                LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.5), Color.backgroundColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            )
        }
    }
}

#Preview {
    ConsultingProView(userManagement: UserManagement())
}
