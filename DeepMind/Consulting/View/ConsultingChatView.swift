//
//  ConsultingChatView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI
import PhotosUI

struct ConsultingChatView: View {
    let consultingData: ConsultingDataModel
    let isModal: Bool
    let mentorInfo: MentorInfoModel
    let menteeInfo: MentorInfoModel?
    let patientInfo: [Bool]
    
    @StateObject var userManagement: UserManagement
    @StateObject private var helper = ChatHelper()

    @State private var animate = false
    @State private var msg = ""
    @State private var containerHeight : CGFloat = 0.0
    @State private var offset : CGFloat = 0
    @State private var lastOffset : CGFloat = 0
    @State private var scrolled = false
    @State private var profileURL: URL? = nil
    @State private var opponentName = ""
    @State private var showProgress = false
    @State private var endTutorial = false
    @State private var questions = ["아동학대 가해자 판정 여부", "아동학대 피해자 판정 여부", "가정폭력 가해자 판정 여부", "가정폭력 피해자 판정 여부", "정신병 및 관련 질환 진단 여부"]

    @State private var selectedPhotos : [PhotosPickerItem] = []
    @State private var showPhotosPicker = false
    @State private var showStatistics = false
    
    @GestureState private var gestureOffset : CGFloat = 0
    
    @Environment(\.presentationMode) var presentationMode
    
    func onChange(){
        DispatchQueue.main.async{
            self.offset = gestureOffset + lastOffset
        }
    }
    
    func getBlurRadius() -> CGFloat{
        let progress = -offset / (UIScreen.main.bounds.height - 100)
        
        return progress
    }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
            
            GeometryReader{proxy in
                VStack {
                    HStack{
                        Spacer()
                        
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark.circle.fill")
                                .foregroundStyle(Color.gray)
                        }
                    }
                    
                    ScrollViewReader{reader in
                        ScrollView{
                            VStack{
                                ForEach(helper.chatList, id : \.id){index in
                                    ChatContentsRow(data: index, consultingData: consultingData, profileURL: profileURL, name: opponentName, isMyMSG: userManagement.userInfo?.UID ?? "" == index.sender)
                                        .onAppear{
                                            if index.id == helper.chatList.last!.id && !scrolled{
                                                reader.scrollTo(helper.chatList.last!.id, anchor : .bottom)
                                            }
                                        }
                                    
                                        .contextMenu{
                                            if index.type == .TEXT{
                                                Button{
                                                    UIPasteboard.general.string = index.message
                                                } label : {
                                                    Label("복사", systemImage : "doc.on.clipboard")
                                                }
                                            }
                                        }
                                    
                                    Spacer().frame(height : 15)
                                }
                            }.onChange(of: helper.chatList, perform: { value in
                                reader.scrollTo(helper.chatList.last!.id, anchor : .bottom)
                            })
                            
                        }.blur(radius: getBlurRadius())
                        
                    }
                    
                }.padding(.horizontal, 20)
                    .frame(height : proxy.size.height - 100)
                    .animation(.easeOut)
            }
            
            KeyboardView{
                GeometryReader{proxy -> AnyView in
                    let height = proxy.frame(in: .global).height
                    
                    return AnyView(
                        ZStack{
                            BlurView(style : .systemThinMaterialDark)
                                .clipShape(CustomCorner(corners : [.topLeft, .topRight], radius : 30))
                            
                            VStack{
                                Capsule()
                                    .fill(Color.white)
                                    .frame(width : 60, height : 4)
                                    .padding(.top)
                                
                                HStack(spacing : 10){
                                    Button(action: {
                                        showPhotosPicker = true
                                    }){
                                        Image(systemName: "plus")
                                            .foregroundStyle(Color.white)
                                            .frame(width : 30, height : 30)
                                            .background(Color.accent)
                                            .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                                    }
                                    
                                    AutoSizingTextField(hint: "메시지를 입력하세요.", text: $msg, containerHeight: $containerHeight)
                                        .padding(.horizontal)
                                        .frame(height : containerHeight <= 120 ? containerHeight : 120)
                                        .background(BlurView(style : .dark))
                                        .clipShape(RoundedRectangle(cornerRadius: 25))
                                    
                                    if !showProgress{
                                        Button(action : {
                                            self.animate = true
                                            
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: {
                                                self.animate = false
                                            })
                                            
                                            if msg != ""{
                                                helper.sendMessage(id: consultingData.id, sender: userManagement.userInfo?.UID ?? "", message: msg, imageIndex: 0){_ in
                                                    self.msg = ""
                                                }
                                            }
                                            
                                        }){
                                            Image(systemName: "arrow.up")
                                                .foregroundColor(.white)
                                                .frame(width : 30, height : 30)
                                                .rotationEffect(Angle(degrees: animate ? 360.0 : 0.0))
                                                .animation(animate ? Animation.linear(duration: 0.25) : nil)
                                                .background(self.msg == "" ? Color.gray : .accent)
                                                .clipShape(Circle())
                                            
                                        }
                                    } else{
                                        ProgressView()
                                    }
                                    
                                }.padding()
                                
                                ConsultingMentorListModel(data: userManagement.userInfo?.type == .PROFESSIONAL ? menteeInfo! : mentorInfo)
                                
                                Spacer().frame(height : 10)
                                
                                Divider()
                                
                                Spacer().frame(height : 10)
                                
                                HStack{
                                    Text("상담 날짜 및 시간")
                                        .foregroundStyle(Color.white)
                                    
                                    Spacer()
                                    
                                    Text("\(consultingData.date) \(consultingData.time)")
                                        .fontWeight(.semibold)
                                        .foregroundStyle(Color.accentColor)
                                }.padding(20)
                                
                                if userManagement.userInfo?.type == .PROFESSIONAL{
                                    HStack(spacing: 15){
                                        Text("상담 정보")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding(20)
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    HStack{
                                        Text(consultingData.message)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    HStack(spacing: 15){
                                        Text("환자 정보")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding(20)
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    if !patientInfo.isEmpty{
                                        ForEach(questions.indices, id: \.self){ index in
                                            Spacer().frame(height: 10)
                                            
                                            HStack{
                                                Text(questions[index])
                                                    .foregroundColor(.white)

                                                Spacer()
                                                
                                                Text(patientInfo[index] ? "예" : "아니오")
                                                    .fontWeight(.semibold)
                                                    .foregroundStyle(Color.accent)
                                            }                                    
                                            .padding(20)

                                        }
                                    } else{
                                        Spacer().frame(height: 10)

                                        Text("환자 정보가 없습니다.")
                                            .foregroundStyle(Color.gray)
                                    }
                                    
                                    Button(action: {
                                        self.showStatistics = true
                                    }){
                                        Image(systemName: "pencil.and.scribble")
                                            .foregroundStyle(Color.accentColor)
                                        
                                        Text("환자 검사 결과 확인하기")
                                            .foregroundStyle(Color.accentColor)
                                    }.buttonStyle(BorderedButtonStyle())
                                    
                                } else{
                                    HStack(spacing : 15) {
                                        Text("방문 상담 정보")
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    .padding(20)
                                    
                                    Divider()
                                        .background(Color.white)
                                    
                                    if mentorInfo.hospitalLocation != nil{
                                        ConsultingHospitalMapView(location: mentorInfo.hospitalLocation!,
                                                                  hospitalAddress: mentorInfo.hospitalAddress ?? "")
                                        .frame(height: 250)
                                        .padding(20)
                                    } else{
                                        Text("등록된 병원 정보가 없습니다.")
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                    }
                                }
                                
                            }
                            .frame(maxHeight : .infinity, alignment: .top)
                        }.offset(y: height - 100)
                            .offset(y : -offset > 0 ? -offset <= (height - 100) ? offset : -(height - 100) : 0)
                            .gesture(DragGesture().updating($gestureOffset, body: {
                                value, out, _ in
                                
                                out = value.translation.height
                                
                                onChange()
                            }).onEnded({value in
                                let maxHeight = height - 100
                                
                                endTutorial = true
                                
                                withAnimation{
                                    if -offset > 100 && -offset < maxHeight / 2 {
                                        offset = -(maxHeight / 3)
                                    }
                                    
                                    else if -offset > maxHeight / 2{
                                        offset = -maxHeight
                                    }
                                    
                                    else{
                                        offset = 0
                                    }
                                }
                                
                                lastOffset = offset
                            }))
                    )
                }.ignoresSafeArea(.all, edges: .bottom)
                
                
            } toolBar:{
                HStack {
                    Spacer()
                    Button(action: {
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }, label: {
                        Text("완료")
                    })
                }.padding()
            }
            
        }.onAppear(perform: {
            helper.getMessages(id: consultingData.id){ _ in}
            helper.getName(uid: (consultingData.mentorUID != userManagement.userInfo?.UID ?? "") ? consultingData.mentorUID : consultingData.menteeUID){ result in
                guard let result = result else{return}
                
                self.opponentName = result
            }
            
            helper.getProfile(uid: (consultingData.mentorUID != userManagement.userInfo?.UID ?? "") ? consultingData.mentorUID : consultingData.menteeUID){ result in
                guard let result = result else{return}
                
                self.profileURL = result
            }
        })
        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhotos)
        .onChange(of: selectedPhotos){ items in
            showProgress = true
            
            helper.sendImage(id: consultingData.id, sender: userManagement.userInfo?.UID ?? "", images: items){ _ in
                showProgress = false
            }
        }
        .sheet(isPresented: $showStatistics){
            ProStatisticsView(uid: consultingData.menteeUID)
        }
        .navigationBarTitle("채팅 상담", displayMode: .inline)
        .navigationBarHidden(!isModal)
    }
}
