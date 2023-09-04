//
//  CommunityMainView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import SwiftUI

struct CommunityMainView: View {
    @StateObject private var helper = CommunityHelper()
    @StateObject var userManagement: UserManagement
    
    @State private var showProgress = true
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            if showProgress{
                VStack{
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                }
            } else{
                LazyVStack{
                    ForEach(helper.articleList, id: \.self){ article in
                        CommunityArticleListModel(data: article)
                    }
                }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
            }

        }.onAppear{
            helper.getAllArticles(){ result in
                guard let result = result else{return}
                
                showProgress = false
            }
        }
        .toolbar{
            ToolbarItemGroup(placement: .topBarTrailing, content: {
                Button(action: {}){
                    Image(systemName: "line.3.horizontal.decrease.circle")
                }
                
                NavigationLink(destination: WriteCommunityView(userManagement: userManagement)){
                    Image(systemName: "plus")
                        .foregroundStyle(Color.red)
                }
            })
        }
    }
}

#Preview {
    CommunityMainView(userManagement: UserManagement())
}
