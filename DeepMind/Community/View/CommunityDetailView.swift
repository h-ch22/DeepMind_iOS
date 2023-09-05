//
//  CommunityDetailView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/5/23.
//

import SwiftUI

struct CommunityDetailView: View {
    @State private var helper = CommunityHelper()
    @State private var comment = ""
    @State private var showProgress = false
    
    @StateObject var userManagement: UserManagement
    let data: CommunityArticleDataModel
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    HStack{
                        Text(data.title)
                            .font(.largeTitle)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                        
                        Spacer()
                        
                        Text(data.createDate)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Text(data.nickName)
                            .font(.caption)
                            .foregroundStyle(Color.gray)
                        
                        Spacer()
                        
                        Text(data.board)
                            .font(.caption)
                            .foregroundStyle(Color.accent)
                    }

                    if data.imageIndex > 0 && !helper.imgList.isEmpty{
                        Spacer().frame(height : 20)

                        TabView{
                            ForEach(helper.imgList, id:\.self){ url in
                                AsyncImage(url: url, content: { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 300, height: 300)
                                }, placeholder: {
                                    ProgressView()
                                })
                            }
                        }.tabViewStyle(.page)
                    }
                    
                    Spacer().frame(height : 20)

                    HStack{
                        Text(data.contents)
                            .foregroundStyle(Color.txt_color)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }

                    Spacer().frame(height : 40)

                    HStack{
                        Text("댓글")
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.txt_color)
                        
                        Text(String(data.commentCount))
                            .foregroundStyle(Color.accent)
                        
                        Spacer()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        TextField("댓글을 작성해보세요!", text: $comment, axis: .vertical)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        if !showProgress{
                            Button(action: {
                                showProgress = true
                                
                                helper.uploadComments(id: data.id,
                                                      contents: comment,
                                                      nickName: userManagement.userInfo?.nickName ?? "",
                                                      author: userManagement.userInfo?.UID ?? ""){ result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        comment = ""
                                        helper.getComments(id: data.id){ result in }
                                    }
                                    
                                    showProgress = false
                                }
                            }){
                                Image(systemName: "arrow.up.circle.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundStyle(comment == "" ? Color.gray : Color.accent)
                            }
                        } else{
                            ProgressView()
                        }
                    }
                    
                    Spacer().frame(height : 20)

                    ForEach(helper.comments, id: \.self){ comment in
                        CommunityCommentsListModel(data: comment, creatorUID: data.author)
                            .padding(20)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 3))
                    }

                    
                }.padding(20)
            }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                .onAppear{
                    helper.downloadImages(id: data.id, imgIndex: data.imageIndex){ result in
                        guard let result = result else{return}
                    }
                    
                    helper.getComments(id: data.id){ result in
                        guard let result = result else{return}
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CommunityDetailView(userManagement: UserManagement(), data: CommunityArticleDataModel(id: "", title: "Test Title", contents: "Test Contents", imageIndex: 0, author: "author", nickName: "nickName", createDate: "date", views: 0, commentCount: 2, board: "Free"))
}
