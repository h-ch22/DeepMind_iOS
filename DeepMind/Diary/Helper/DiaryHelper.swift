//
//  DiaryHelper.swift
//  DeepMind
//
//  Created by 하창진 on 8/7/23.
//

import Firebase
import FirebaseFirestore
import FirebaseStorage

class DiaryHelper: ObservableObject{
    @Published var diaryList: [DiaryContentsModel] = []
    @Published var urlList: [URL?] = []
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    private func convertEmotionCodeToEmotion(code: String) -> DiaryEmotionModel{
        switch code{
        case "HAPPY" : return .HAPPY
        case "GREAT" : return .GREAT
        case "GOOD" : return .GOOD
        case "SOSO" : return .SOSO
        case "BAD" : return .BAD
        case "SAD" : return .SAD
        case "STAY_ALONE" : return .STAY_ALONE
        case "ANGRY" : return .ANGRY
        default: return .SOSO
        }
    }
    
    private func convertEmotionToCode(emotion: DiaryEmotionModel) -> String{
        switch emotion{
        case .HAPPY: return "HAPPY"
        case .GREAT: return "GREAT"
        case .GOOD: return "GOOD"
        case .SOSO: return "SOSO"
        case .BAD: return "BAD"
        case .SAD: return "SAD"
        case .STAY_ALONE: return "STAY_ALONE"
        case .ANGRY: return "ANGRY"
        }
    }
    
    func remove(id: String, completion: @escaping(_ result: Bool?) -> Void){
        
    }
    
    func uploadDiary(title: String, contents: String, emotionCode: DiaryEmotionModel, photos: [UIImage] , images: [UIImage], markUps: [UIImage], completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        db.collection("Diary").document(auth.currentUser?.uid ?? "").setData([
            "NO_DATA" : nil
        ]){ _ in
            self.db.collection("Diary").document(self.auth.currentUser?.uid ?? "").collection("Diaries").document(dateFormatter.string(from: Date())).setData([
                "title" : AES256Util.encrypt(string: title),
                "contents" : AES256Util.encrypt(string: contents),
                "emotion" : AES256Util.encrypt(string: self.convertEmotionToCode(emotion: emotionCode)),
                "imgCount" : images.count + markUps.count + photos.count
            ]){ error in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                } else{
                    if images.count + markUps.count + photos.count > 0{
                        var cnt = 0
                        
                        if !photos.isEmpty{
                            for image in photos{
                                let storageRef = self.storage.reference().child("Diary/\(self.auth.currentUser?.uid ?? "")/\(dateFormatter.string(from: Date()))/\(cnt).png")
                                storageRef.putData(image.pngData()!, metadata: nil){ (_, error) in
                                    if error != nil{
                                        print(error?.localizedDescription)
                                        completion(false)
                                        return
                                    }
                                }
                                
                                cnt+=1
                            }
                        }

                        if !images.isEmpty{
                            for image in images{
                                let storageRef = self.storage.reference().child("Diary/\(self.auth.currentUser?.uid ?? "")/\(dateFormatter.string(from: Date()))/\(cnt).png")
                                storageRef.putData(image.pngData()!, metadata: nil){ (_, error) in
                                    if error != nil{
                                        print(error?.localizedDescription)
                                        completion(false)
                                        return
                                    }
                                    
                                }
                                
                                cnt+=1
                            }
                        }

                        if !markUps.isEmpty{
                            for image in markUps{
                                let storageRef = self.storage.reference().child("Diary/\(self.auth.currentUser?.uid ?? "")/\(dateFormatter.string(from: Date()))/\(cnt).png")
                                storageRef.putData(image.pngData()!, metadata: nil){ (_, error) in
                                    if error != nil{
                                        print(error?.localizedDescription)
                                        completion(false)
                                        return
                                    }
                                    
                                }
                                
                                cnt+=1
                            }
                        }
                        
                        completion(true)
                        return
                    } else{
                        completion(true)
                        return
                    }
                }
            }
        }

    }
    
    func getDiaryList(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Diary").document(auth.currentUser?.uid ?? "")
            .collection("Diaries").getDocuments(){(querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                } else{
                    for document in querySnapshot!.documents{
                        let date = document.documentID
                        let title = document.get("title") as? String ?? ""
                        let contents = document.get("contents") as? String ?? ""
                        let emotion = self.convertEmotionCodeToEmotion(code: AES256Util.decrypt(encoded: document.get("emotion") as? String ?? ""))
                        let imgCount = document.get("imgCount") as? Int ?? 0
                        
                        self.diaryList.append(DiaryContentsModel(title: title, contents: contents, date: date, emotion: emotion, imgCount: imgCount))
                    }
                    
                    self.diaryList.sort(by: {$0.date < $1.date})
                    
                    completion(true)
                    return
                }
            }
    }
    
    func getURL(id: String, imgCount: Int, completion: @escaping(_ result: Bool?) -> Void){
        self.urlList.removeAll()
        
        for i in 0..<imgCount{
            storage.reference().child("Diary/\(self.auth.currentUser?.uid ?? "")/\(id)/\(i).png").downloadURL(){(url, error) in
                if error != nil{
                    completion(false)
                    return
                } else{
                    self.urlList.append(url)
                }
            }
        }
                
        completion(true)
        return
    }
}
