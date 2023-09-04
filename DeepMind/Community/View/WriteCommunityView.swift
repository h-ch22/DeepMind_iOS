//
//  WriteCommunityView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import SwiftUI

struct WriteCommunityView: View {
    @StateObject var userManagement: UserManagement
    
    @State private var helper = CommunityHelper()
    @State private var title = ""
    @State private var contents = ""
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    TextField("제목", text: $title)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Spacer().frame(height: 10)
                    
                    TextField("내용", text: $contents, axis:. vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                }.padding(20)
            }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    WriteCommunityView(userManagement: UserManagement())
}
