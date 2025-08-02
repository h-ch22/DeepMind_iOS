//
//  ConsultingReservationView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/3/23.
//

import SwiftUI
import PhotosUI

struct ConsultingReservationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State private var showProgress = true
    @State private var date = Date()
    @State private var reservationList: [String] = []
    @State private var times = ["09", "10", "11", "13", "14", "15", "16", "17"]
    @State private var selectedTime = ""
    @State private var selectedType: ConsultingMethodType = .CHAT
    @State private var message = ""
    @State private var selectedPhotos : [PhotosPickerItem] = []
    @State private var imageData : [UIImage] = []
    @State private var showPhotosPicker = false
    @State private var showAlert = false
    @State private var alertModel: CommonAlertModel = .CONFIRM
    
    @StateObject var helper: ConsultingHelper
    @StateObject var userManagement: UserManagement
    
    let data: MentorInfoModel
    
    private func getAvailableTimes(){
        times = ["09", "10", "11", "13", "14", "15", "16", "17"]
        
        for reservated in reservationList{
            let hour = reservated.split(separator: ":")[0]
            
            if times.contains(String(hour)){
                let index = times.firstIndex(of: String(hour))
                
                if index != nil{
                    times.remove(at: index!)
                }
            }
        }
    }
    
    var body: some View {
        NavigationView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                ScrollView{
                    VStack{
                        ConsultingMentorListModel(data: data)
                        
                        Spacer().frame(height: 20)
                        
                        DatePicker("상담 날짜 선택", selection: $date, in: Date()... , displayedComponents: [.date])
                            .datePickerStyle(.graphical)
                        
                        Spacer().frame(height: 10)
                        
                        if showProgress{
                            HStack{
                                ProgressView()
                                
                                Text("상담 가능한 시간을 불러오고 있습니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                            }
                        } else{
                            HStack{
                                Text("상담 시간 선택")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            ScrollView(.horizontal){
                                LazyHStack{
                                    ForEach(times, id: \.self){ time in
                                        Button(action: {
                                            selectedTime = time
                                        }){
                                            Text(time)
                                                .foregroundStyle(selectedTime == time ? Color.white : Color.txt_color)
                                                .padding(5)
                                                .background(Circle().foregroundStyle(selectedTime == time ? Color.accentColor : Color.backgroundColor))
                                        }
                                        
                                        Spacer().frame(width: 10)
                                    }
                                }
                            }
                            
                            Spacer().frame(height: 20)
                            
                            HStack{
                                Text("상담 방식 선택")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            HStack{
                                Spacer()
                                
                                if data.hospitalLocation != nil{
                                    Button(action: {
                                        selectedType = .INTERVIEW
                                    }){
                                        VStack{
                                            Image(systemName: "person.2.wave.2.fill")
                                                .foregroundStyle(selectedType == .INTERVIEW ? Color.white : Color.txt_color)
                                            
                                            Text("방문 상담")
                                                .foregroundStyle(selectedType == .INTERVIEW ? Color.white : Color.txt_color)
                                        }.padding(20)
                                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(selectedType == .INTERVIEW ? Color.accentColor : Color.btn_color).shadow(radius: 5))
                                    }
                                    
                                    Spacer()
                                }
                                
                                Button(action: {
                                    selectedType = .CHAT
                                }){
                                    VStack{
                                        Image(systemName: "message.fill")
                                            .foregroundStyle(selectedType == .CHAT ? Color.white : Color.txt_color)
                                        
                                        Text("채팅 상담")
                                            .foregroundStyle(selectedType == .CHAT ? Color.white : Color.txt_color)
                                    }.padding(20)
                                        .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(selectedType == .CHAT ? Color.accentColor : Color.btn_color).shadow(radius: 5))
                                }
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 20)
                            
                            HStack{
                                Text("상담 내용")
                                    .fontWeight(.semibold)
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            Spacer().frame(height: 10)
                            
                            TextField("상담 내용 입력", text: $message, axis:. vertical)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if !selectedPhotos.isEmpty || !imageData.isEmpty{
                                Spacer().frame(height: 10)
                                
                                ScrollView(.horizontal){
                                    HStack{
                                        ForEach(imageData, id:\.self){ data in
                                            Image(uiImage: data)
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .aspectRatio(contentMode: .fit)
                                            
                                            Spacer().frame(width: 5)
                                        }
                                    }
                                }
                            }
                            
                            Spacer().frame(height: 10)
                            
                            Button(action: {
                                showPhotosPicker = true
                            }){
                                HStack{
                                    Image(systemName: "photo.fill")
                                    Text("이미지 추가")
                                }
                            }.buttonStyle(.bordered)
                            
                            if selectedType == .INTERVIEW{
                                Spacer().frame(height: 20)
                                
                                HStack{
                                    Text("내원 상담 위치 안내")
                                        .foregroundStyle(Color.txt_color)
                                        .fontWeight(.semibold)
                                    
                                    Spacer()
                                }
                                
                                Spacer().frame(height: 10)
                                
                                ConsultingHospitalMapView(location: data.hospitalLocation!,
                                                          hospitalAddress: data.hospitalAddress ?? "")
                                .frame(height: 250)
                            }
                        }
                    }.padding(20)
                        .onChange(of: date){
                            showProgress = true
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy. MM. dd."
                            
                            helper.getReservationList(uid: data.mentorUID, date: dateFormatter.string(from: date)){ result in
                                guard let result = result else{return}
                                
                                reservationList = result
                                
                                getAvailableTimes()
                                
                                showProgress = false
                            }
                        }
                        .navigationTitle(Text("상담 예약하기"))
                        .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhotos)
                        .onChange(of: selectedPhotos){ items in
                            self.imageData.removeAll()
                            
                            for item in items{
                                item.loadTransferable(type: Data.self){ result in
                                    switch result{
                                    case .success(let image):
                                        if let image{
                                            self.imageData.append(UIImage(data: image)!)
                                        } else{
                                            print("No supported content type found.")
                                        }
                                        
                                    case .failure(let error):
                                        print(error)
                                    }
                                }
                            }
                        }
                        .toolbar{
                            ToolbarItemGroup(placement: .topBarLeading, content: {
                                Button(action: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }){
                                    Image(systemName: "xmark")
                                }
                            })
                            
                            ToolbarItemGroup(placement: .topBarTrailing, content: {
                                if showProgress{
                                    ProgressView()
                                } else{
                                    if selectedTime != "" && message != ""{
                                        Button("완료"){
                                            alertModel = .CONFIRM
                                            showAlert = true
                                        }
                                    }
                                }
                            })
                        }
                        .alert(isPresented: $showAlert, content: {
                            switch alertModel {
                            case .CONFIRM:
                                return Alert(title: Text("예약 확인"), message: Text("상담 예약을 진행하시겠습니까?"), primaryButton: .default(Text("예")){
                                    showProgress = true
                                    
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "yyyy. MM. dd."
                                    
                                    helper.reserveConsulting(mentorName: data.mentorName, menteeName: userManagement.userInfo?.name ?? "", date: dateFormatter.string(from: date), time: selectedTime, message: message, type: selectedType, images: imageData, uid: userManagement.userInfo?.UID ?? "", mentorUID: data.mentorUID){ result in
                                        guard let result = result else{return}
                                        
                                        if result{
                                            alertModel = .SUCCESS
                                            showAlert = true
                                            showProgress = false
                                        } else{
                                            alertModel = .ERROR
                                            showAlert = true
                                            showProgress = false
                                        }
                                    }
                                }, secondaryButton: .default(Text("아니오")))
                            case .SUCCESS:
                                return Alert(title: Text("예약 완료"), message: Text("상담 예약이 완료되었습니다."), dismissButton: .default(Text("확인")){
                                    self.presentationMode.wrappedValue.dismiss()
                                })
                            case .ERROR:
                                return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")){
                                    
                                })
                            }
                        })
                        .onAppear{
                            showProgress = true
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy. MM. dd."
                            
                            helper.getReservationList(uid: data.mentorUID, date: dateFormatter.string(from: date)){ result in
                                guard let result = result else{return}
                                
                                reservationList = result
                                
                                getAvailableTimes()
                                
                                showProgress = false
                            }
                        }
                }.background(Color.background.edgesIgnoringSafeArea(.all))
                    .animation(.easeInOut)
            }
        }
    }
}

#Preview {
    ConsultingReservationView(helper: ConsultingHelper(), userManagement: UserManagement(), data: MentorInfoModel(mentorUID: "", mentorName: "Mentor", mentorProfile: nil, hospitalLocation: nil, hospitalAddress: "", rate: 0.0))
}
