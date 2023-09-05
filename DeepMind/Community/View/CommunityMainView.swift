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
    @State private var currentBoard = "전체"
    
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
                VStack{
                    LazyVStack{
                        ForEach(helper.articleList, id: \.self){ article in
                            NavigationLink(destination: CommunityDetailView(userManagement: userManagement, data: article)){
                                CommunityArticleListModel(data: article)
                                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 3))
                            }
                        }
                    }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                    
                    Spacer()
                }.padding(20)
            }
            
        }.onAppear{
            helper.getAllArticles(){ result in
                guard let result = result else{return}
                
                showProgress = false
            }
        }
        .toolbar{
            ToolbarItemGroup(placement: .topBarTrailing, content: {
                Menu(content: {
                    Picker("게시판 선택", selection: $currentBoard){
                        ForEach(helper.filterList, id: \.self){
                            Text($0)
                        }
                    }
                }, label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                })
                
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
