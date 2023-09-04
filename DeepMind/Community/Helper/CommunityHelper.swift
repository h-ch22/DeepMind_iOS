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
                            CommunityArticleDataModel(title: AES256Util.decrypt(encoded: title),
                                                      contents: AES256Util.decrypt(encoded: contents),
                                                      imageIndex: imageIndex,
                                                      author: author,
                                                      nickName: AES256Util.decrypt(encoded: nickName),
                                                      createDate: createDate,
                                                      views: views,
                                                      commentCount: result,
                                                      board: AES256Util.decrypt(encoded: board))
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
            "nickName": AES256Util.encrypt(string: nickName),
            "createDate": dateFormatter.string(from: Date()),
            "views": 0,
            "board": AES256Util.encrypt(string: board)
        ]){error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if(imgs.count > 0){
                for img in imgs{
                    self.storage.reference().child("Community/\(docRef.documentID)").putData(img.pngData()!){_, error in
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
