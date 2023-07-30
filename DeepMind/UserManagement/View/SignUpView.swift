//
//  SignUpView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct SignUpView: View {
    @State private var titleList = ["반가워요!", "E-Mail을 입력해주세요", "비밀번호를 입력해주세요", "비밀번호를 확인해주세요",
                                    "이름을 입력해주세요.", "닉네임을 입력해주세요", "연락처와 생년월일을 입력해주세요"]
    @State private var email = ""
    @State private var password = ""
    @State private var checkPassword = ""
    @State private var name = ""
    @State private var nickName = ""
    @State private var birthDay = ""
    @State private var phone = ""
    @State private var date = Date()
    
    @State private var acceptEULA = false
    @State private var acceptPrivacy = false
    @State private var acceptSensitive = false
    @State private var index = 0
    @State private var isPasswordEditing: Bool = false
    @State private var alertModel : SignUpAlertModel? = nil
    @State private var showAlert = false
    @State private var showOverlay = false
    @State private var changeView = false
    
    @StateObject var helper: UserManagement

    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    Text(titleList[index])
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)
                        .transition(AnyTransition.opacity.animation(.easeInOut(duration:1)))

                    Group{
                        HStack {
                            Image(systemName: "at.circle.fill")
                            
                            TextField("E-Mail", text:$email, onEditingChanged: {(editing) in
                                if !editing{
                                    if index < 2{
                                        index += 1
                                    }
                                }
                                
                            })
                            .keyboardType(.emailAddress)
                        }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(index == 0)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "key.fill")
                            
                            SecureField("비밀번호", text:$password, onCommit: {
                                if index < 3{
                                    index += 1
                                }
                            })
                        }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(index < 2)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)
                        
                        HStack {
                            Image(systemName: "key.fill")
                            
                            SecureField("한번 더", text:$checkPassword, onCommit: {
                                if index < 4{
                                    index += 1
                                }
                            })
                        }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(index < 3)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                    }
                    
                    Group{
                        Spacer().frame(height : 20)

                        HStack {
                            Image(systemName: "person.fill.viewfinder")
                            
                            TextField("이름", text:$name, onEditingChanged: {(editing) in
                                if !editing{
                                    if index < 5{
                                        index += 1
                                    }
                                }
                                
                            })
                        }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(index < 4)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)

                        HStack {
                            Image(systemName: "person.circle.fill")
                            
                            TextField("닉네임", text:$nickName, onEditingChanged: {(editing) in
                                if !editing{
                                    if index < 6{
                                        index += 1
                                    }
                                }
                                
                            })
                        }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(index < 5)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)


                    }
                    
                    Group{
                        HStack {
                            Image(systemName: "iphone.gen3.circle.fill")
                            
                            TextField("연락처", text:$phone)
                            .keyboardType(.numberPad)
                        }
                        .padding(20)
                        .padding([.horizontal], 20)
                        .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(Color.btn_color).shadow(radius: 5)
                            .padding([.horizontal],15))
                        .isHidden(index < 6)
                        .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)

                        DatePicker("생년월일", selection: $date, displayedComponents: [.date])
                            .isHidden(index < 6)
                            .transition(AnyTransition.opacity.animation(.easeInOut))

                        Spacer().frame(height : 20)

                        HStack{
                            CheckBox(checked : $acceptEULA, title: "최종 사용권 계약서 (필수)")
                            
                            Spacer()
                        }.isHidden(index < 6)
                            .transition(AnyTransition.opacity.animation(.easeInOut))
                        
                        Spacer().frame(height : 20)

                        HStack{
                            CheckBox(checked : $acceptPrivacy, title: "개인정보 수집 및 처리방침 (필수)")
                            
                            Spacer()
                            
                        }.isHidden(index < 6)
                            .transition(AnyTransition.opacity.animation(.easeInOut))

                        Spacer().frame(height : 20)

                        HStack{
                            CheckBox(checked : $acceptSensitive, title: "민감정보 수집 및 처리방침 (필수)")
                            
                            Spacer()
                        }.isHidden(index < 6)
                            .transition(AnyTransition.opacity.animation(.easeInOut))

                        Spacer().frame(height : 20)
                    }
                    
                    Button(action : {
                        if password.count < 6{
                            alertModel = .WEAK_PASSWORD
                            showAlert = true
                        } else if password != checkPassword{
                            alertModel = .PASSWORD_MISMATCH
                            showAlert = true
                        } else if !acceptEULA || !acceptPrivacy || !acceptSensitive{
                            alertModel = .REQUIRED_LICENSE_ACCEPT
                            showAlert = true
                        } else if !email.contains("@"){
                            alertModel = .INVALID_EMAIL_TYPE
                            showAlert = true
                        } else{
                            showOverlay = true
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yy/MM/dd"
                            
                            self.birthDay = dateFormatter.string(from: self.date)
                            
                            helper.signUp(email: self.email, password: self.password, nickName: self.nickName, name: self.name, phone: self.phone, birthDay: self.birthDay){ result in
                                guard let result = result else{return}
                                                                
                                if !result{
                                    alertModel = .ERROR
                                    showAlert = true
                                } else{
                                    changeView = true
                                }
                                
                                showOverlay = false
                            }
                        }
                    }){
                        HStack{
                            Text("다음 단계로")
                                .foregroundColor(.white)
                            
                            Image(systemName : "chevron.right")
                                .foregroundColor(.white)
                        }.padding([.vertical], 20)
                            .padding([.horizontal], 120)
                            .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(Color.accentColor).shadow(radius: 5))
                    }.isHidden(index < 6)
                        .transition(AnyTransition.opacity.animation(.easeInOut))

                }.animation(.easeInOut).padding(20)
                    .onAppear{
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                            self.index += 1
                        })
                    }
                    .overlay(ProcessView().isHidden(!showOverlay))
                    .alert(isPresented: $showAlert, error: alertModel){ _ in
                        
                    } message: {error in
                        Text(error.recoverySuggestion ?? "")
                    }
                    .fullScreenCover(isPresented: $changeView, content: {
                        UploadFeatureView(helper: helper)
                    })
                    .navigationTitle(Text("회원가입"))
                    .navigationBarHidden(true)
            }
        }
    }
}

#Preview {
    SignUpView(helper: UserManagement())
}
