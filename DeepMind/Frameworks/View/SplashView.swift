//
//  SplashView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct SplashView: View {
    @State private var showSignInView = false
    @State private var showHome = false
    @EnvironmentObject var helper : UserManagement
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                Spacer()
                
                Image("ic_appstore")
                    .resizable()
                    .frame(width : 150, height : 150)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                HStack{
                    Text("Deep")
                        .font(.title)
                        .foregroundStyle(Color.txt_color)
                    
                    Text("Mind")
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.txt_color)
                }
                
                Spacer()
                
                ProgressView()
            }.onAppear{
                if UserDefaults.standard.string(forKey: "auth_email") != nil &&
                    UserDefaults.standard.string(forKey: "auth_password") != nil{
                    let laHelper = LAHelper()
                    laHelper.authenticate(){result in
                        guard let result = result else{return}
                        
                        if result{
                            helper.signIn(email : AES256Util.decrypt(encoded: UserDefaults.standard.string(forKey: "auth_email")!), password : AES256Util.decrypt(encoded: UserDefaults.standard.string(forKey: "auth_password")!)){ result in
                                guard let result = result else{return}
                                
                                if result{
                                    showHome = true
                                } else{
                                    showSignInView = true
                                }
                            }
                        } else{
                            showSignInView = true
                        }
                    }
                    

                } else{
                    showSignInView = true
                }
            }
            .navigationBarHidden(true)
            .fullScreenCover(isPresented: $showSignInView){
                SignInView()
            }
            .fullScreenCover(isPresented: $showHome){
                TabManager().environmentObject(helper)
            }
        }
    }
}

#Preview {
    SplashView()
}
