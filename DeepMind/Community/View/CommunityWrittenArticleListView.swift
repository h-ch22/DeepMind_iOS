//
//  CommunityWrittenArticleListView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/1/23.
//

import SwiftUI

struct CommunityWrittenArticleListView: View {
    @StateObject var helper: CommunityHelper
    @StateObject var userManagement: UserManagement
    
    @State private var showProgress = true
    
    let userData: CommunityUserDataModel
    
    var body: some View {
        ZStack{
            Color.background.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    if userData.profile != nil{
                        AsyncImage(url: userData.profile!, content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                        }, placeholder: {
                            ProgressView()
                        })
                    } else{
                        Image("ic_appstore")
                            .resizable()
                            .frame(width : 100, height : 100)
                            .clipShape(Circle())
                    }
                    
                    Spacer().frame(width: 10)
                    
                    VStack(alignment: .leading){
                        Text(userData.nickName)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                        
                        HStack{
                            Text("작성한 게시글")

                            Text("\(helper.writtenArticleList.count) 개")
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.accent)
                        }
                    }
                    
                    Spacer()
                }
                
                Spacer().frame(height: 10)
                
                if showProgress{
                    ProgressView()
                } else{
                    ScrollView{
                        LazyVStack{
                            ForEach(helper.writtenArticleList, id: \.self){article in
                                NavigationLink(destination: CommunityDetailView(userManagement: userManagement, helper: helper, data: article)){
                                    CommunityArticleListModel(data: article)
                                }
                            }
                        }
                    }

                }
                
                Spacer()
            }.padding(20)
                .onAppear{
                    helper.getWrittenArticles(uid: userData.uid)
                    showProgress = false
                }
                .navigationTitle(Text("작성한 게시글 보기"))
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CommunityWrittenArticleListView(helper: CommunityHelper(), userManagement: UserManagement(), userData: CommunityUserDataModel(uid: "", nickName: "", profile: nil))
}
