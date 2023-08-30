//
//  UserTypeSelectionView.swift
//  DeepMind
//
//  Created by 하창진 on 8/30/23.
//

import SwiftUI

struct UserTypeSelectionView: View {
    @StateObject var helper: UserManagement

    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Text("환영합니다!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.txt_color)
                    
                    Spacer()
                }
                
                NavigationLink(destination: SignUpView(helper: helper, type: .CUSTOMER)){
                    HStack{
                        VStack(alignment: .leading){
                            Text("상담 대상자 또는 부모님 등의 고객이신가요?")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("일반 사용자 회원가입")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt_color)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.txt_color)
                    }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                }
                
                Spacer().frame(height: 20)
                
                NavigationLink(destination: SignUpView(helper: helper, type: .PROFESSIONAL)){
                    HStack{
                        VStack(alignment: .leading){
                            Text("의사/교사/선생님/상담사 등 전문가 고객이신가요?")
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text("전문가 회원가입")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt_color)
                        }
                        
                        Spacer()
                        
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.title)
                            .foregroundStyle(Color.txt_color)
                    }.padding(20).background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
                }
                
            }.padding(20)
        }
    }
}

#Preview {
    UserTypeSelectionView(helper: UserManagement())
}
