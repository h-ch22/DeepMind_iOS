//
//  ConsultingDetailView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/3/23.
//

import SwiftUI

struct ConsultingDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var helper: ConsultingHelper
    @StateObject var userManagement: UserManagement
    
    @State private var percentage: Double = 50
    @State private var color = Color.cyan

    @State private var showProgress = false
    @State private var showAlert = false
    @State private var alertModel: CommonAlertModel = .CONFIRM
    @State private var showChatView = false
    @State private var showPatientInfoProgress = true
    @State private var patientInfo: [Bool] = []
    @State private var questions = ["아동학대 가해자 판정 여부", "아동학대 피해자 판정 여부", "가정폭력 가해자 판정 여부", "가정폭력 피해자 판정 여부", "정신병 및 관련 질환 진단 여부"]
    
    let data: ConsultingDataModel
    let isDone: Bool
    let isUnRated: Bool
    let isModal: Bool
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                if helper.mentorInfo == nil || (userManagement.userInfo?.type == .PROFESSIONAL && helper.menteeInfo == nil){
                    VStack{
                        Spacer()
                        
                        ProgressView()
                        
                        Spacer()
                    }
                }
                
                else{
                    ScrollView{
                        VStack{
                            Group{
                                if userManagement.userInfo?.type == .PROFESSIONAL{
                                    ConsultingMentorListModel(data: helper.menteeInfo!)
                                } else{
                                    ConsultingMentorListModel(data: helper.mentorInfo!)
                                }
                                
                                Spacer().frame(height : 10)
                                
                                Divider()
                                
                                Spacer().frame(height : 10)
                                
                                HStack{
                                    Text("상담 날짜 및 시간")
                                        .foregroundStyle(Color.txt_color)
                                    
                                    Spacer()
                                    
                                    Text("\(data.date) \(data.time)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.accentColor)
                                }.padding(10)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color))
                                
                                Spacer().frame(height: 10)
                                
                                VStack{
                                    HStack{
                                        Text("상담 방법")
                                            .foregroundStyle(Color.txt_color)
                                        
                                        Spacer()
                                        
                                        Text(data.type == .INTERVIEW ? "방문 상담" : "채팅 상담")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.accentColor)
                                    }
                                    
                                    if data.type == .INTERVIEW && helper.mentorInfo!.hospitalLocation != nil{
                                        Spacer().frame(height: 10)

                                        ConsultingHospitalMapView(location: helper.mentorInfo!.hospitalLocation!,
                                                                  hospitalAddress: helper.mentorInfo!.hospitalAddress ?? "")
                                        .frame(height: 250)
                                    }
                                    
                                }
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color))
                                
                                Spacer().frame(height: 10)
                            }

                            Group{
                                HStack{
                                    Text("상담 상세")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.txt_color)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                if data.imageIndex > 0{
                                    TabView{
                                        ForEach(helper.imgList, id:\.self){ url in
                                            AsyncImage(url: url, content: { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 300, height: 300)
                                            }, placeholder: {
                                                ProgressView()
                                            })
                                        }
                                    }.tabViewStyle(.page)
                                        .frame(width: 300, height: 300)
                                    
                                    Spacer().frame(height: 10)
                                }
                                
                                HStack{
                                    Text(data.message)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .foregroundStyle(Color.txt_color)
                                    
                                    Spacer()
                                }
                                
                                if userManagement.userInfo?.type == .PROFESSIONAL{
                                    Spacer().frame(height : 10)
                                    
                                    Divider()
                                    
                                    Spacer().frame(height : 10)
                                    
                                    HStack{
                                        Text("환자 정보")
                                            .fontWeight(.semibold)
                                            .foregroundStyle(Color.txt_color)
                                        
                                        Spacer()
                                    }
                                    
                                    if showPatientInfoProgress{
                                        ProgressView()
                                    } else{
                                        if !patientInfo.isEmpty{
                                            
                                            ForEach(questions.indices){ index in
                                                Spacer().frame(height: 10)

                                                HStack{
                                                    Text(questions[index])
                                                        .foregroundStyle(Color.txt_color)
                                                    
                                                    Spacer()
                                                    
                                                    Text(patientInfo[index] ? "예" : "아니오")
                                                        .fontWeight(.semibold)
                                                        .foregroundStyle(Color.accent)
                                                }
                                            }
                                        } else{
                                            Spacer().frame(height: 10)

                                            Text("환자 정보가 없습니다.")
                                                .foregroundStyle(Color.gray)
                                        }
         
                                    }
                                }

                            }

                            Spacer().frame(height : 10)
                            
                            Divider()
                            
                            Spacer().frame(height : 10)
                            
                            if showProgress{
                                ProgressView()
                            } else{
                                if !isDone{
                                    HStack{
                                        if data.type == .CHAT{
                                            Button(action: {
                                                showChatView = true
                                            }){
                                                HStack{
                                                    Image(systemName: "message.fill")
                                                        .foregroundStyle(Color.accent)
                                                    
                                                    Text("채팅으로 이동")
                                                        .foregroundStyle(Color.accent)
                                                }
                                            }.buttonStyle(.bordered)
                                            
                                            Spacer().frame(width: 20)
                                        }
                                        
                                        Button(action: {
                                            alertModel = .CONFIRM
                                            showAlert = true
                                        }){
                                            HStack{
                                                Image(systemName: "xmark")
                                                    .foregroundStyle(Color.red)
                                                
                                                Text("상담 취소하기")
                                                    .foregroundStyle(Color.red)
                                            }
                                        }.buttonStyle(.bordered)
                                        
   
                                        
                                    }
                                } else if isUnRated{
                                    HStack{
                                        Text("상담 만족도 평가")
                                            .foregroundStyle(Color.txt_color)
                                            .fontWeight(.semibold)
                                        
                                        Spacer()
                                        
                                        Text("\(String(Int(percentage)))%")
                                            .font(.title)
                                            .foregroundStyle(color)
                                            .fontWeight(.semibold)
                                    }
                                    
                                    Spacer().frame(height: 10)
                                    
                                    DailyEmotionSlider(percentage: $percentage, color: $color)
                                        .frame(height:50)

                                    Spacer().frame(height: 10)
                                    
                                    Button(action: {
                                        
                                    }){
                                        HStack{
                                            Text("완료")
                                                .foregroundStyle(Color.white)
                                        }.frame(width: 250, height: 50)
                                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(color))

                                    }
                                }
                            }
                            
                        }.padding(20)
                    }
                }
                
            }                           
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading, content: {
                    Button("닫기"){
                        self.presentationMode.wrappedValue.dismiss()
                    }
                })
            }
            .navigationTitle(Text("상담 세부 정보"))
            .onAppear{
                if userManagement.userInfo?.type == .PROFESSIONAL{
                    helper.getMenteeInfo(uid: data.menteeUID){ result in
                        guard let result = result else{return}
                    }
                    
                    userManagement.getFeatures(uid: data.menteeUID){ result in
                        guard let result = result else{return}
                        
                        self.patientInfo = result
                        showPatientInfoProgress = false
                    }
                }
                
                helper.getMentorInfo(uid: data.mentorUID){ result in
                    guard let result = result else{return}
                }

                
                helper.downloadImages(id: data.id, imageCount: data.imageIndex){ result in
                    guard let result = result else{return}
                }
            }
            .alert(isPresented: $showAlert, content: {
                switch alertModel {
                case .CONFIRM:
                    return Alert(title: Text("상담 취소 확인"), message: Text("상담 예약을 취소하시겠습니까?"), primaryButton: .default(Text("예")){
                        showProgress = true
                        
                        helper.cancelConsulting(id: data.id, imageCount: data.imageIndex){ result in
                            guard let result = result else{return}
                            
                            if result{
                                alertModel = .SUCCESS
                                showAlert = true
                            } else{
                                alertModel = .ERROR
                                showAlert = true
                            }
                            
                            showProgress = false
                        }
                    }, secondaryButton: .default(Text("아니오")))
                case .SUCCESS:
                    return Alert(title: Text("취소 완료"), message: Text("상담 예약이 취소되었습니다."), dismissButton: .default(Text("확인")){
                        self.presentationMode.wrappedValue.dismiss()
                    })
                case .ERROR:
                    return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")){
                        
                    })
                }
            })
            .fullScreenCover(isPresented: $showChatView, content: {
                ConsultingChatView(consultingData: data, isModal: isModal, mentorInfo: helper.mentorInfo!, menteeInfo: userManagement.userInfo?.type == .PROFESSIONAL ? helper.menteeInfo : nil, patientInfo: patientInfo, userManagement: userManagement)
            })
            .navigationBarHidden(!isModal)
            .animation(.easeInOut)
            .onChange(of: self.percentage){ (newVal) in
                if newVal <= 12.5{
                    color = Color.red
                } else if newVal <= 25{
                    color = Color.gray
                } else if newVal <= 37.5{
                    color = Color.blue
                } else if newVal <= 50{
                    color = Color.cyan
                } else if newVal <= 62.5{
                    color = Color.orange
                } else if newVal <= 75{
                    color = Color.yellow
                } else if newVal <= 87.5{
                    color = Color.pink.opacity(0.6)
                } else if newVal <= 100{
                    color = Color.pink
                }
            }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
