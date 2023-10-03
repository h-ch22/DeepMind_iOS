//
//  ConsultingProView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import SwiftUI

struct ConsultingProView: View {
    @StateObject var userManagement: UserManagement
    @StateObject private var helper = ConsultingHelper()
    
    @State private var showRegisterHospitalView = false
    
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
                    }
                    .sheet(isPresented: $showRegisterHospitalView, content: {
                        ConsultingHospitalSelectionView(helper: helper, userManagement: userManagement)
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
