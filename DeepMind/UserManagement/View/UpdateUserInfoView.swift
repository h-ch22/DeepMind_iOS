//
//  UpdateUserInfoView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/1/23.
//

import SwiftUI

struct UpdateUserInfoView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var helper: UserManagement
    
    @State private var newValue = ""
    @State private var checkNewValue = ""
    @State private var showProgress = false
    @State private var showAlert = false
    @State private var showPasswordErrorAlert = false
    
    @State private var alertModel: CommonAlertModel = .CONFIRM
    
    let updateType: UpdateUserInfoModel
    
    private func getAssets() -> (String, String, String){
        switch updateType{
        case .NICK_NAME:
            return ("person.circle.fill", "닉네임을", "변경할 닉네임을 입력해주세요.")
            
        case .PASSWORD:
            return ("lock.circle.fill", "비밀번호를", "변경할 비밀번호를 입력해주세요.")
            
        case .PHONE:
            return ("iphone.gen3.circle.fill", "연락처를", "변경할 연락처를 입력해주세요.")
        }
    }

    var body: some View {
        NavigationView{
            ZStack{
                Color.background.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Image(systemName: getAssets().0)
                        .resizable()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(Color.txt_color)
                    
                    Text("\(AES256Util.decrypt(encoded: helper.userInfo?.email ?? "")) 계정의 \(getAssets().1) 변경합니다.")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)
                    
                    Spacer().frame(height: 10)
                    
                    Text(getAssets().2)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer().frame(height : 20)
                    
                    switch updateType{
                    case .NICK_NAME, .PHONE:
                        HStack {
                            Image(systemName: getAssets().0)
                            
                            TextField(getAssets().1, text:$newValue)
                                .keyboardType(updateType == .PHONE ? .phonePad : .default)
                        }
                        .foregroundStyle(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                    case .PASSWORD:
                        HStack {
                            Image(systemName: getAssets().0)
                            
                            SecureField("새 비밀번호", text:$newValue)
                        }
                        .foregroundStyle(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                        Spacer().frame(height : 10)
                        
                        HStack {
                            Image(systemName: getAssets().0)
                            
                            SecureField("비밀번호 확인", text:$checkNewValue)
                        }
                        .foregroundStyle(Color.txt_color)
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                                        .padding([.horizontal],15))
                        
                        Spacer().frame(height : 10)

                        Text("보안을 위해 6자리 이상의 비밀번호를 설정해주세요.")
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                }.padding(20)
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading, content: {
                            Button("닫기"){
                                self.presentationMode.wrappedValue.dismiss()
                            }
                        })
                        
                        ToolbarItem(placement: .topBarTrailing, content: {
                            if !showProgress{
                                Button("완료"){
                                    if updateType != .PASSWORD{
                                        if newValue != ""{
                                            alertModel = .CONFIRM
                                            showAlert = true
                                        }
                                    } else{
                                        if newValue != checkNewValue{
                                            showPasswordErrorAlert = true
                                        } else{
                                            alertModel = .CONFIRM
                                            showAlert = true
                                        }
                                    }

                                }.alert(isPresented: $showPasswordErrorAlert, content:{
                                    return Alert(title: Text("비밀번호 불일치"), message: Text("비밀번호와 비밀번호 확인이 일치하지 않습니다."), dismissButton: .default(Text("확인")))
                                })
                                .isHidden(newValue == "" || (updateType == .PASSWORD && newValue.count < 6))
                            } else{
                                ProgressView()
                            }

                        })
                    }
                    .navigationTitle(Text("사용자 정보 변경"))
                    .navigationBarTitleDisplayMode(.inline)
                    .alert(isPresented: $showAlert, content: {
                        switch alertModel{
                        case .CONFIRM:
                            return Alert(title: Text("정보 변경 확인"), message: Text("\(getAssets().1) 변경하시겠습니까?"), primaryButton: .default(Text("예")){
                                showProgress = true
                                
                                switch updateType {
                                case .NICK_NAME:
                                    helper.updateNickName(nickName: newValue){ result in
                                        guard let result = result else{return}
                                        
                                        if result{
                                            alertModel = .SUCCESS
                                            showAlert = true
                                        } else{
                                            alertModel = .ERROR
                                            showAlert = true
                                        }
                                    }
                                case .PASSWORD:
                                    helper.updatePassword(newPassword: newValue){ result in
                                        guard let result = result else{return}
                                        
                                        if result{
                                            alertModel = .SUCCESS
                                            showAlert = true
                                        } else{
                                            alertModel = .ERROR
                                            showAlert = true
                                        }
                                    }
                                case .PHONE:
                                    helper.updatePhone(phone: newValue){ result in
                                        guard let result = result else{return}
                                        
                                        if result{
                                            alertModel = .SUCCESS
                                            showAlert = true
                                        } else{
                                            alertModel = .ERROR
                                            showAlert = true
                                        }
                                    }
                                }
                                
                                showProgress = false
                            }, secondaryButton: .default(Text("아니오")){
                                
                            })
                            
                        case .SUCCESS:
                            return Alert(title: Text("업데이트 완료"), message: Text("요청하신 작업을 정상적으로 처리하였습니다."), dismissButton: .default(Text("확인")){
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                        case .ERROR:
                            return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생하였습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")){
                                self.presentationMode.wrappedValue.dismiss()
                            })
                        }
                    })
            }
        }
    }
}

#Preview {
    UpdateUserInfoView(helper: UserManagement(), updateType: .PASSWORD)
}
