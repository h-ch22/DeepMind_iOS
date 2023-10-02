//
//  CommunityHelper.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

class CommunityHelper: ObservableObject{
    @Published var articleList: [CommunityArticleDataModel] = []
    @Published var filteredArticleList: [CommunityArticleDataModel] = []
    @Published var latestArticles: [CommunityArticleDataModel] = []
    @Published var writtenArticleList: [CommunityArticleDataModel] = []
    
    @Published var boardList: [String:String] = ["자유 게시판": "Free", "질문 게시판": "Question", "맛집 게시판": "Restaurant", "병원 추천" : "Hospital", "문화/생활" : "Culture", "이벤트": "Event", "자녀방": "Children", "구인/구직": "JobSearch", "판매": "Market", "HTP 검사 결과 공유": "HTP"]
    @Published var filterList = ["전체", "자유 게시판", "질문 게시판", "맛집 게시판", "병원 추천", "문화/생활", "이벤트", "자녀방", "구인/구직", "판매", "HTP 검사 결과 공유"]
    
    @Published var imgList: [URL] = []
    @Published var comments: [CommunityCommentDataModel] = []
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func getLatestArticles(completion: @escaping(_ result: Bool?) -> Void){
        self.db.collection("Community").order(by: "createDate").limit(to: 5).getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    let title = document.get("title") as? String ?? ""
                    let contents = document.get("contents") as? String ?? ""
                    let imageIndex = document.get("imageIndex") as? Int ?? 0
                    let author = document.get("author") as? String ?? ""
                    let nickName = document.get("nickName") as? String ?? ""
                    let createDate = document.get("createDate") as? String ?? ""
                    let views = document.get("views") as? Int ?? 0
                    let board = document.get("board") as? String ?? ""
                    
                    self.getCommentCount(id: document.documentID){ result in
                        guard let result = result else {return}
                        
                        if imageIndex > 0{
                            self.getThumbnail(id: document.documentID){ thumbnailURL in
                                self.latestArticles.append(
                                    CommunityArticleDataModel(id: document.documentID,
                                                              title: AES256Util.decrypt(encoded: title),
                                                              contents: AES256Util.decrypt(encoded: contents),
                                                              imageIndex: imageIndex,
                                                              author: author,
                                                              nickName: AES256Util.decrypt(encoded: nickName),
                                                              createDate: createDate,
                                                              views: views,
                                                              commentCount: result,
                                                              board: self.boardList.someKey(forValue: AES256Util.decrypt(encoded: board)) ?? "",
                                                              profile: nil,
                                                              thumbnail: thumbnailURL)
                                )
                            }
                        } else{
                            self.latestArticles.append(
                                CommunityArticleDataModel(id: document.documentID,
                                                          title: AES256Util.decrypt(encoded: title),
                                                          contents: AES256Util.decrypt(encoded: contents),
                                                          imageIndex: imageIndex,
                                                          author: author,
                                                          nickName: AES256Util.decrypt(encoded: nickName),
                                                          createDate: createDate,
                                                          views: views,
                                                          commentCount: result,
                                                          board: self.boardList.someKey(forValue: AES256Util.decrypt(encoded: board)) ?? "",
                                                          profile: nil,
                                                          thumbnail: nil)
                            )
                        }
                        
                        
                    }
                }
            }
        }
    }
    
    func filterList(filter: String){
        self.filteredArticleList.removeAll()
        
        for article in articleList{
            if article.board == filter{
                filteredArticleList.append(article)
            }
        }
    }
    
    func getWrittenArticles(uid: String){
        writtenArticleList.removeAll()
        
        for article in articleList{
            if article.author == uid{
                writtenArticleList.append(article)
            }
        }
    }
    
    func getAllArticles(completion: @escaping(_ result: Bool?) -> Void){
        self.articleList.removeAll()
        
        self.db.collection("Community").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    let title = document.get("title") as? String ?? ""
                    let contents = document.get("contents") as? String ?? ""
                    let imageIndex = document.get("imageIndex") as? Int ?? 0
                    let author = document.get("author") as? String ?? ""
                    let nickName = document.get("nickName") as? String ?? ""
                    let createDate = document.get("createDate") as? String ?? ""
                    let views = document.get("views") as? Int ?? 0
                    let board = document.get("board") as? String ?? ""
                    
                    self.getCommentCount(id: document.documentID){ result in
                        guard let result = result else {return}
                        
                        self.getProfile(uid: author){ profileURL in
                            if imageIndex > 0{
                                self.getThumbnail(id: document.documentID){ thumbnailURL in
                                    self.articleList.append(
                                        CommunityArticleDataModel(id: document.documentID,
                                                                  title: AES256Util.decrypt(encoded: title),
                                                                  contents: AES256Util.decrypt(encoded: contents),
                                                                  imageIndex: imageIndex,
                                                                  author: author,
                                                                  nickName: AES256Util.decrypt(encoded: nickName),
                                                                  createDate: createDate,
                                                                  views: views,
                                                                  commentCount: result,
                                                                  board: self.boardList.someKey(forValue: AES256Util.decrypt(encoded: board)) ?? "",
                                                                  profile: nil,
                                                                  thumbnail: thumbnailURL)
                                    )
                                }
                            } else{
                                self.articleList.append(
                                    CommunityArticleDataModel(id: document.documentID,
                                                              title: AES256Util.decrypt(encoded: title),
                                                              contents: AES256Util.decrypt(encoded: contents),
                                                              imageIndex: imageIndex,
                                                              author: author,
                                                              nickName: AES256Util.decrypt(encoded: nickName),
                                                              createDate: createDate,
                                                              views: views,
                                                              commentCount: result,
                                                              board: self.boardList.someKey(forValue: AES256Util.decrypt(encoded: board)) ?? "",
                                                              profile: nil,
                                                              thumbnail: nil)
                                )
                            }
                        }
                        
                        
                    }
                }
                
                completion(true)
                return
            } else{
                completion(false)
                return
            }
        }
    }
    
    func downloadImages(id: String, imgIndex: Int, completion: @escaping(_ result: Bool?) -> Void){
        imgList.removeAll()
        
        for i in 0..<imgIndex{
            storage.reference().child("Community/\(id)/\(i).png").downloadURL(){(downloadURL, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                }
                
                self.imgList.append(downloadURL!)
            }
        }
        
        completion(true)
    }
    
    func getProfile(uid: String, completion: @escaping(_ result: URL?) -> Void){
        self.storage.reference().child("Profile/\(uid)/profile.png").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(nil)
                return
            }
            
            completion(downloadURL)
            return
        }
    }
    
    func getComments(id: String, completion: @escaping(_ result: Bool?) -> Void){
        comments.removeAll()
        
        db.collection("Community").document(id).collection("Comments").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    let author = document.get("author") as? String ?? ""
                    let nickName = document.get("nickName") as? String ?? ""
                    let contents = document.get("contents") as? String ?? ""
                    let uploadDate = document.get("uploadDate") as? String ?? ""
                    
                    self.getProfile(uid: author){ profileURL in
                        self.comments.append(CommunityCommentDataModel(author: author,
                                                                       nickName: AES256Util.decrypt(encoded: nickName),
                                                                       contents: AES256Util.decrypt(encoded: contents),
                                                                       uploadDate: uploadDate,
                                                                       profile: profileURL))
                    }
                    
                    
                }
                
                completion(true)
                return
            }
        }
    }
    
    func uploadComments(id: String, contents: String, nickName: String, author: String, completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd. kk:mm:ss.SSSS"
        
        db.collection("Community").document(id).collection("Comments").addDocument(data: [
            "author": author,
            "nickName": nickName,
            "contents": AES256Util.encrypt(string: contents),
            "uploadDate": dateFormatter.string(from: Date())
        ]){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
    
    private func getCommentCount(id: String, completion: @escaping(_ result: Int?) -> Void){
        db.collection("Community").document(id).collection("Comments").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(0)
                return
            }
            
            if querySnapshot != nil{
                completion(querySnapshot?.documents.count)
            } else{
                completion(0)
                return
            }
        }
    }
    
    private func getThumbnail(id: String, completion: @escaping(_ result: URL?) -> Void){
        storage.reference().child("Community/\(id)/0.png").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(nil)
                return
            }
            
            completion(downloadURL)
            return
        }
    }
    
    func remove(id: String, completion: @escaping(_ result: Bool?) -> Void){
        let commentsRef = self.db.collection("Community").document(id).collection("Comments")
        commentsRef.getDocuments(){(querySnapshot, error) in
            if error == nil && querySnapshot != nil{
                for document in querySnapshot!.documents{
                    commentsRef.document(document.documentID).delete()
                }
            }
        }
        
        db.collection("Community").document(id).delete(){error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                completion(true)
                return
            }
        }
    }
    
    func removeComment(id: String, commentId: String, completion: @escaping(_ result: Bool?) -> Void){
        self.db.collection("Community").document(id).collection("Comments").document(commentId).delete(){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                completion(true)
                return
            }
        }
    }
    
    func upload(title: String, contents: String, author: String, nickName: String, board: String, imgs: [UIImage], completion: @escaping(_ result: Bool?) -> Void){
        let docRef = db.collection("Community").document()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd. kk:mm:ss.SSSS"
        
        docRef.setData([
            "title": AES256Util.encrypt(string: title),
            "contents": AES256Util.encrypt(string: contents),
            "imageIndex": imgs.count,
            "author": author,
            "nickName": nickName,
            "createDate": dateFormatter.string(from: Date()),
            "views": 0,
            "board": AES256Util.encrypt(string: boardList[board] ?? "")
        ]){error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if(imgs.count > 0){
                for i in 0..<imgs.count{
                    let storageRef = self.storage.reference().child("Community/\(docRef.documentID)/\(i).png")
                    storageRef.putData(imgs[i].pngData()!){_, error in
                        if error != nil{
                            print(error?.localizedDescription)
                            completion(false)
                            return
                        } else{
                            completion(true)
                            return
                        }
                    }
                }
            } else{
                completion(true)
                return
            }
        }
    }
}
