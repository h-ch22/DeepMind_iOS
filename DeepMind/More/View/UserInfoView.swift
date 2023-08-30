//
//  UserInfoView.swift
//  DeepMind
//
//  Created by 하창진 on 8/30/23.
//

import SwiftUI

struct UserInfoView: View {
    @StateObject var helper: UserManagement
    
    @State private var showProgress = false
    @State private var showSignOutAlert = false
    @State private var showSecessionAlert = false
    @State private var showSignInView = false
    
    @State private var alertModel: UserStatusChangeResultModel = .CONFIRM
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                
                VStack{
                    Spacer()
                    
                    Image("ic_appstore")
                        .resizable()
                        .frame(width : 80, height : 80)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                    
                    Spacer().frame(height : 5)
                    
                    if helper.userInfo?.type == .PROFESSIONAL{
                        HStack{
                            Text(AES256Util.decrypt(encoded: helper.userInfo?.name ?? ""))
                                .font(.title2)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt_color)
                            
                            ProBadgeView()
                        }
                    } else{
                        Text(AES256Util.decrypt(encoded: helper.userInfo?.name ?? ""))
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                    }
                    
                    Spacer().frame(height : 5)
                    
                    Button(action:{}){
                        Text("프로필 이미지 변경")
                            .font(.caption)
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action : {}){
                        HStack{
                            Image(systemName: "person.circle.fill")
                            
                            VStack(alignment : .leading){
                                Text("닉네임 변경")
                                    .foregroundColor(.txt_color)
                            }
                            
                            Spacer()
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action : {}){
                        HStack{
                            Image(systemName: "checklist")
                            
                            VStack(alignment : .leading){
                                Text("민감정보 변경")
                                    .foregroundColor(.txt_color)
                            }
                            
                            Spacer()
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action : {}){
                        HStack{
                            Image(systemName: "key.horizontal.fill")
                            
                            VStack(alignment : .leading){
                                Text("비밀번호 변경")
                                    .foregroundColor(.txt_color)
                            }
                            
                            Spacer()
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                    }
                    
                    Spacer().frame(height : 20)
                    
                    Button(action : {}){
                        HStack{
                            Image(systemName: "iphone.gen3")
                            
                            VStack(alignment : .leading){
                                Text("연락처 변경")
                                    .foregroundColor(.txt_color)
                            }
                            
                            Spacer()
                        }.padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                    }
                }
                
                Spacer().frame(height : 20)
                
                Button(action : {}){
                    HStack{
                        Image(systemName: "xmark.bin.fill")
                        
                        VStack(alignment : .leading){
                            Text("민감정보 삭제 요청 및 동의 철회")
                                .multilineTextAlignment(.leading)
                                .foregroundColor(.txt_color)
                        }
                        
                        Spacer()
                    }.padding(20)
                        .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).shadow(radius: 2, x:0, y:2))
                }
                
                Spacer().frame(height : 20)
                
                HStack{
                    Button(action : {
                        alertModel = .CONFIRM
                        showSignOutAlert = true
                    }){
                        Text("로그아웃")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }          
                    .alert(isPresented: $showSignOutAlert, content:{
                        switch alertModel{
                        case .CONFIRM:
                            return Alert(title: Text("로그아웃 확인"), message: Text("로그아웃 시 자동 로그인이 해제되며, 다시 로그인해야 합니다. 계속하시겠습니까?"), primaryButton: .default(Text("예")){
                                showProgress = true
                                helper.signOut(){result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        showProgress = false
                                        alertModel = .SUCCESS
                                        showSignOutAlert = true
                                    } else{
                                        showProgress = false
                                        alertModel = .FAIL
                                        showSignOutAlert = true
                                    }
                                }
                            }, secondaryButton: .default(Text("아니오")))
                            
                        case .SUCCESS:
                            return Alert(title: Text("작업 완료"), message: Text("로그아웃이 완료되었습니다."), dismissButton: .default(Text("확인")){
                                showSignInView = true
                            })
                            
                        case .FAIL:
                            return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        }
                    })
                    
                    Text(" 또는 ")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Button(action : {
                        alertModel = .CONFIRM
                        showSecessionAlert = true
                    }){
                        Text("회원 탈퇴")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .alert(isPresented: $showSecessionAlert, content:{
                        switch alertModel{
                        case .CONFIRM:
                            return Alert(title: Text("회원탈퇴 확인"), message: Text("회원탈퇴 시 모든 정보가 제거되며, 다시 가입해야 합니다. 계속하시겠습니까?"), primaryButton: .default(Text("예")){
                                showProgress = true
                                helper.secession(){result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        showProgress = false
                                        alertModel = .SUCCESS
                                        showSecessionAlert = true
                                    } else{
                                        showProgress = false
                                        alertModel = .FAIL
                                        showSecessionAlert = true
                                    }
                                }
                            }, secondaryButton: .default(Text("아니오")))
                            
                        case .SUCCESS:
                            return Alert(title: Text("작업 완료"), message: Text("회원탈퇴가 완료되었습니다."), dismissButton: .default(Text("확인")){
                                showSignInView = true
                            })
                            
                        case .FAIL:
                            return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                        }
                    })
                }
                
                Spacer()
            }.padding(20)
            
        }
        .overlay(ProcessView().isHidden(!showProgress))
        
        .fullScreenCover(isPresented: $showSignInView, content: {
            SignInView()
        })
        
    }
}

#Preview {
    UserInfoView(helper: UserManagement())
}
