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
    @Published var boardList: [String:String] = ["자유 게시판": "Free", "질문 게시판": "Question", "맛집 게시판": "Restaurant", "병원 추천" : "Hospital", "문화/생활" : "Culture", "이벤트": "Event", "자녀방": "Children", "구인/구직": "JobSearch", "판매": "Market"]
    @Published var filterList = ["전체", "자유 게시판", "질문 게시판", "맛집 게시판", "병원 추천", "문화/생활", "이벤트", "자녀방", "구인/구직", "판매"]
    @Published var imgList: [URL] = []
    @Published var comments: [CommunityCommentDataModel] = []
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func getAllArticles(completion: @escaping(_ result: Bool?) -> Void){
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
                                                      board: self.boardList.someKey(forValue: AES256Util.decrypt(encoded: board)) ?? "")
                        )
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
                    
                    self.comments.append(CommunityCommentDataModel(author: author,
                                                                   nickName: AES256Util.decrypt(encoded: nickName),
                                                                   contents: AES256Util.decrypt(encoded: contents),
                                                                   uploadDate: uploadDate))
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
