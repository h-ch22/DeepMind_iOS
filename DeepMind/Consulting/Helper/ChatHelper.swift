//
//  ChatHelper.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import PhotosUI
import SwiftUI

class ChatHelper: ObservableObject{
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    @Published var chatList: [ChatDataModel] = []
    
    func getMessages(id: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Consulting").document(id).collection("Chat").addSnapshotListener{ querySnapshot, error in
            guard let snapshot = querySnapshot else{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            snapshot.documentChanges.forEach{ diff in
                let data = diff.document.data()

                switch diff.type{
                case .added:
                    let sender = data["sender"] as? String ?? ""
                    let message = AES256Util.decrypt(encoded: data["message"] as? String ?? "")
                    let sentTime = data["sentTime"] as? String ?? ""
                    let imageIndex = data["imageIndex"] as? Int ?? 0
                    let type = imageIndex > 0 ? ChatType.IMAGES : ChatType.TEXT
                    
                    var images: [URL?] = []
                    
                    if imageIndex > 0{
                        self.getImages(id: id, docId: diff.document.documentID, imageIndex: imageIndex){ result in
                            guard let result = result else{return}
                            
                            self.chatList.append(
                                ChatDataModel(id: diff.document.documentID, sender: sender, message: message, imgCount: imageIndex, imgs: images, sentTime: sentTime, type: type)
                            )
                        }
                    } else{
                        self.chatList.append(
                            ChatDataModel(id: diff.document.documentID, sender: sender, message: message, imgCount: imageIndex, imgs: [], sentTime: sentTime, type: type)
                        )
                    }
                    
                    self.chatList.sort(by: {$0.sentTime < $1.sentTime})
                    
                case .modified, .removed:
                    break
                }
            }
        }
    }
    
    func sendMessage(id: String, sender: String, message: String, imageIndex: Int, completion: @escaping(_ result: String?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd. kk:mm:ss"
        
        let docRef = db.collection("Consulting").document(id).collection("Chat").document()
        docRef.setData([
            "sender": sender,
            "message": AES256Util.encrypt(string: message),
            "sentTime": dateFormatter.string(from: Date()),
            "imageIndex": imageIndex
        ]){error in
            if error != nil{
                print(error?.localizedDescription)
                completion("")
                return
            } else{
                completion(docRef.documentID)
                return
            }
        }
    }
    
    func sendImage(id: String, sender: String, images: [PhotosPickerItem], completion: @escaping(_ result: Bool?) -> Void){
        self.sendMessage(id: id, sender: sender, message: "\(images.count)개의 이미지를 보냈습니다.", imageIndex: images.count){ result in
            guard let result = result else{return}
            
            if result == ""{
                completion(false)
                return
            } else{
                for i in 0..<images.count{
                    let storageRef = self.storage.reference().child("Consulting/\(id)/Chat/\(result)/\(i).png")
                    images[i].loadTransferable(type: Data.self){ result in
                        switch result {
                        case .success(let image):
                            if let image{
                                storageRef.putData(UIImage(data: image)!.pngData()!){_, error in
                                    if error != nil{
                                        print(error?.localizedDescription)
                                        completion(false)
                                        return
                                    }
                                }
                            }

                        case .failure(let failure):
                            print(failure)
                        }
                        
                    }

                }
                
                completion(true)
                return
            }
        }
    }
    
    func getImages(id: String, docId: String, imageIndex: Int, completion: @escaping(_ result: [URL?]?) -> Void){
        var imageURL: [URL?] = []
        
        for i in 0..<imageIndex{
            self.storage.reference().child("Consulting/\(id)/Chat/\(docId)/\(i).png").downloadURL(){downloadURL, error in
                if error != nil{
                    print(error?.localizedDescription)
                } else{
                    imageURL.append(downloadURL)
                }
                
                if i == imageIndex - 1{
                    completion(imageURL)
                    return
                }
            }
            
        }

    }
    
    func getProfile(uid: String, completion: @escaping(_ result: URL?) -> Void){
        self.storage.reference().child("Profile/\(uid)/profile.png").downloadURL(){downloadURL, error in
            if error != nil{
                print(error?.localizedDescription)
                completion(nil)
                return
            } else{
                completion(downloadURL)
                return
            }
        }
    }
    
    func getName(uid: String, completion: @escaping(_ result: String?) -> Void){
        self.db.collection("Users").document(uid).getDocument(){document, error in
            if error != nil{
                print(error?.localizedDescription)
                completion("")
                return
            }
            
            if document != nil{
                completion(AES256Util.decrypt(encoded: document!.get("name") as? String ?? ""))
                return
            } else{
                completion("")
                return
            }
        }
    }
}
