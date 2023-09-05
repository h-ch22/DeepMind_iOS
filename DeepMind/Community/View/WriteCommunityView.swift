//
//  WriteCommunityView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import SwiftUI
import PhotosUI

struct WriteCommunityView: View {
    @StateObject var userManagement: UserManagement
    
    @State private var helper = CommunityHelper()
    @State private var title = ""
    @State private var contents = ""
    
    @State private var showActionSheet = false
    @State private var selectedPhotos : [PhotosPickerItem] = []
    @State private var imageData : [UIImage] = []
    @State private var photoData: [UIImage] = []
    @State private var showCamera = false
    @State private var showPhotosPicker = false
    @State private var showProgress = false
    @State private var currentBoard = "자유 게시판"
    @State private var uploadSuccess = false
    @State private var showAlert = false
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                HStack{
                    Spacer()
                    
                    Picker("게시판 선택", selection: $currentBoard){
                        ForEach(helper.boardList.keys.sorted(by: >), id:\.self){
                            Text($0)
                        }
                    }.pickerStyle(MenuPickerStyle())
                }
                TextField("제목", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer().frame(height: 10)
                
                TextField("내용", text: $contents, axis:. vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Spacer()
                
                HStack{
                    Button(action: {
                        showActionSheet = true
                    }){
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .confirmationDialog("미디어 추가", isPresented: $showActionSheet){
                        Button("사진 촬영"){
                            showCamera = true
                        }
                        Button("사진 선택"){
                            showPhotosPicker = true
                        }
                        
                        Button("취소", role: .cancel){
                            self.showActionSheet = false
                        }
                    }
                    
                    if selectedPhotos.isEmpty && photoData.isEmpty{
                        Spacer()
                    } else{
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(imageData, id:\.self){ data in
                                    Image(uiImage: data)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Spacer().frame(width: 5)
                                }
                                
                                ForEach(photoData, id:\.self){ data in
                                    Image(uiImage: data)
                                        .resizable()
                                        .frame(width: 30, height: 30)
                                        .aspectRatio(contentMode: .fit)
                                    
                                    Spacer().frame(width: 5)
                                }
                            }
                        }
                        
                    }
                }
            }.padding(20)
                .navigationBarTitleDisplayMode(.inline)
                .photosPicker(isPresented: $showPhotosPicker, selection: $selectedPhotos)
                .onChange(of: selectedPhotos){ items in
                    self.imageData.removeAll()
                    
                    for item in items{
                        item.loadTransferable(type: Data.self){ result in
                            switch result{
                            case .success(let image):
                                if let image{
                                    self.imageData.append(UIImage(data: image)!)
                                } else{
                                    print("No supported content type found.")
                                }
                                
                            case .failure(let error):
                                print(error)
                            }
                        }
                    }
                }
                .fullScreenCover(isPresented: $showCamera){
                    ImagePicker(sourceType: .camera, selectedImage: self.$photoData)
                }
                .alert(isPresented: $showAlert, content:{
                    if uploadSuccess{
                        return Alert(title: Text("업로드 완료"), message: Text("업로드가 완료되었습니다."), dismissButton: .default(Text("확인")))
                    } else{
                        return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                    }
                })
                .toolbar{
                    ToolbarItemGroup(placement: .topBarTrailing, content: {
                        if showProgress{
                            ProgressView()
                        } else{
                            Button(action: {
                                showProgress = true
                                
                                var imgs: [UIImage] = []
                                
                                for img in imageData{
                                    imgs.append(img)
                                }
                                
                                for photo in photoData{
                                    imgs.append(photo)
                                }
                                
                                helper.upload(title: title,
                                              contents: contents,
                                              author: userManagement.userInfo?.UID ?? "",
                                              nickName: userManagement.userInfo?.nickName ?? "",
                                              board: currentBoard,
                                              imgs: imgs){ result in
                                    guard let result = result else{return}
                                    
                                    if result{
                                        uploadSuccess = true
                                    } else{
                                        uploadSuccess = false
                                    }
                                    
                                    showAlert = true
                                    showProgress = false
                                }
                            }){
                                Text("완료")
                            }
                        }
                    })
                }
        }
    }
}

#Preview {
    WriteCommunityView(userManagement: UserManagement())
}
