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
    @State private var searchText = ""
    
    var filteredDatas: [CommunityArticleDataModel] {
        if searchText.isEmpty{
            return currentBoard == "전체" ? helper.articleList : helper.filteredArticleList
        } else{
            if currentBoard == "전체"{
                return helper.articleList.filter{
                    $0.title.localizedStandardContains(searchText)
                }
            } else{
                return helper.filteredArticleList.filter{
                    $0.title.localizedStandardContains(searchText)
                }
            }
        }
    }
    
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
                List(filteredDatas){ article in
                    NavigationLink(destination: CommunityDetailView(userManagement: userManagement, helper: helper, data: article)){
                        CommunityArticleListModel(data: article)
                    }
                }
            }
        }.onAppear{            
            helper.getAllArticles(){ result in
                guard let result = result else{return}
                
                showProgress = false
            }
        }
        .searchable(
            text: $searchText,
            placement: .navigationBarDrawer,
            prompt: "게시물 제목을 검색해보세요!"
        )
        .onChange(of: currentBoard){(newVal) in
            if newVal != "전체"{
                helper.filterList(filter: currentBoard)
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
                    Image(systemName: currentBoard == "전체" ? "line.3.horizontal.decrease.circle" : "line.3.horizontal.decrease.circle.fill")
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
