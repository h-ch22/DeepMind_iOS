//
//  CommunityDetailView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/5/23.
//

import SwiftUI

struct CommunityDetailView: View {
    @State private var comment = ""
    @State private var showProgress = false
    @State private var showImages = false
    @State private var showComments = false
    @State private var showAlert = false
    @State private var alertModel: CommonAlertModel = .CONFIRM
    @State private var deletionModel: CommunityDeletionModel? = nil
    @State private var showOverlay = false
    @State private var selectedComment: CommunityCommentDataModel? = nil
    
    @StateObject var userManagement: UserManagement
    @StateObject var helper: CommunityHelper
    
    @Environment(\.presentationMode) var presentationMode
    
    let data: CommunityArticleDataModel
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    HStack{
                        NavigationLink(destination: CommunityWrittenArticleListView(helper: helper,
                                                                                    userManagement: userManagement,
                                                                                    userData: CommunityUserDataModel(uid: data.author, nickName: data.nickName, profile: data.profile))){
                            HStack{
                                if data.profile != nil{
                                    AsyncImage(url: data.profile!, content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 30, height: 30)
                                            .clipShape(Circle())
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                } else{
                                    Image("ic_appstore")
                                        .resizable()
                                        .frame(width : 30, height : 30)
                                        .clipShape(Circle())
                                }
                                
                                Spacer().frame(width: 10)
                                
                                Text(data.nickName)
                                    .font(.caption)
                                    .foregroundStyle(Color.accent)
                            }

                        }

                        Spacer()

                        VStack(alignment: .trailing){
                            Text(data.createDate)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                            
                            Text(data.board)
                                .font(.caption)
                                .foregroundStyle(Color.gray)
                        }

                    }
                    
                    Spacer().frame(height : 20)
                    
                    if data.imageIndex > 0 && showImages{
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
                            .frame(width: 300, height: 300)
                    } else if data.imageIndex > 0 && !showImages{
                        Spacer().frame(height : 20)
                        
                        ProgressView()
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Text(data.contents)
                            .foregroundStyle(Color.txt_color)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                    
                    if data.fileURL != nil{
                        Spacer().frame(height : 20)

                        HStack{
                            Text(data.fileURL!.lastPathComponent)
                                .fontWeight(.semibold)
                                .foregroundStyle(Color.txt_color)
                            
                            Spacer()
                            
                            Button(action: {
                                
                            }){
                                Image(systemName: "arrow.down.square.fill")
                                    .foregroundStyle(Color.accentColor)
                            }
                            
                        }.padding(10)
                            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
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
                                if comment != ""{
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
                    
                    if showComments{
                        ForEach(helper.comments, id: \.self){ comment in
                            CommunityCommentsListModel(data: comment, creatorUID: data.author)
                                .padding(20)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 3))
                                .swipeActions(edge: .leading, allowsFullSwipe: false){
                                    if userManagement.userInfo?.UID ?? "" == comment.author{
                                        Button{
                                            deletionModel = .COMMENT
                                            selectedComment = comment
                                            alertModel = .CONFIRM
                                            showAlert = true
                                        } label: {
                                            Label("제거", systemImage: "trash.fill")
                                        }.tint(.red)
                                    }
                                    
                                }
                        }
                        
                    }
                    
                    
                }.padding(20)
            }.background(Color.backgroundColor.edgesIgnoringSafeArea(.all))
                .onAppear{
                    helper.downloadImages(id: data.id, imgIndex: data.imageIndex){ result in
                        guard let result = result else{return}
                        
                        if result{
                            showImages = true
                        }
                    }
                    
                    helper.getComments(id: data.id){ result in
                        guard let result = result else{return}
                        
                        if result{
                            showComments = true
                        }
                    }
                }
                .toolbar{
                    ToolbarItemGroup(placement: .topBarTrailing, content: {
                        if userManagement.userInfo?.UID ?? "" == data.author{
                            Button(action: {
                                deletionModel = .ARTICLE
                                alertModel = .CONFIRM
                                showAlert = true
                            }){
                                Image(systemName: "trash.fill")
                                    .foregroundStyle(Color.red)
                            }
                        }
                    })
                }
                .alert(isPresented: $showAlert, content: {
                    switch alertModel{
                    case .CONFIRM:
                        return Alert(title: Text("제거 확인"), message: Text("선택한 글을 제거하시겠습니까?"), primaryButton: .default(Text("예")){
                            if deletionModel == .ARTICLE{
                                helper.remove(id: data.id){ result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        alertModel = .SUCCESS
                                        showAlert = true
                                    } else{
                                        alertModel = .ERROR
                                        showAlert = true
                                    }
                                }
                            } else if deletionModel == .COMMENT{
                                helper.removeComment(id: data.id, commentId: selectedComment?.author ?? ""){ result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        alertModel = .SUCCESS
                                        showAlert = true
                                    } else{
                                        alertModel = .ERROR
                                        showAlert = true
                                    }
                                }
                            }
                        }, secondaryButton: .default(Text("아니오")))
                        
                    case .SUCCESS:
                        return Alert(title: Text("작업 완료"), message: Text("요청하신 작업이 정상적으로 처리되었습니다."), dismissButton: .default(Text("확인")){
                            self.presentationMode.wrappedValue.dismiss()
                        })
                        
                    case .ERROR:
                        return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부 또는 이 작업을 수행할 수 있는 권한이 있는지 확인하신 후 다시 시도하십시오."), dismissButton: .default(Text("확인")){
                            
                        })
                    }
                })
                .overlay(ProcessView().isHidden(!showOverlay))
                .navigationTitle(Text(data.title))
        }
    }
}

#Preview {
    CommunityDetailView(userManagement: UserManagement(), helper: CommunityHelper(), data: CommunityArticleDataModel(id: "", title: "Test Title", contents: "Test Contents", imageIndex: 0, author: "author", nickName: "nickName", createDate: "date", views: 0, commentCount: 2, board: "Free", profile: nil, thumbnail: nil))
}
