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
    @Published var emotionList: [StatisticsEmotionDataModel] = []
    @Published var emotionStack: [String: String] = [:]
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    static func convertEmotionCodeToEmotion(code: String) -> DiaryEmotionModel{
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
    
    static func convertEmotionCodeToString(code: DiaryEmotionModel?) -> String?{
        switch code{
        case .HAPPY: return "행복해요"
        case .GREAT: return "최고예요"
        case .GOOD: return "좋아요"
        case .SOSO: return "그저 그래요"
        case .BAD: return "안좋아요"
        case .SAD: return "슬퍼요"
        case .STAY_ALONE: return "혼자 있고 싶어요"
        case .ANGRY: return "화나요"
        default: return nil
        }
    }
    
    static func convertCodeToEmoji(code: DiaryEmotionModel?) -> String?{
        switch code{
        case .HAPPY: return "🥰 행복해요"
        case .GREAT: return "😆 최고예요"
        case .GOOD: return "😀 좋아요"
        case .SOSO: return "🙂 그저 그래요"
        case .BAD: return "☹️ 안좋아요"
        case .SAD: return "😢 슬퍼요"
        case .STAY_ALONE: return "😣 혼자 있고 싶어요"
        case .ANGRY: return "😡 화나요"
        default: return nil
        }
    }
    
    static func indexToEmotion(index: Int) -> DiaryEmotionModel?{
        switch index{
        case 0:
            return .HAPPY
            
        case 1:
            return .GREAT
            
        case 2:
            return .GOOD
            
        case 3:
            return .SOSO
            
        case 4:
            return .BAD
            
        case 5:
            return .SAD
            
        case 6:
            return .STAY_ALONE
            
        case 7:
            return .ANGRY
            
        default:
            return nil
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
                "emotion" : AES256Util.encrypt(string: emotionCode.description),
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
                        let emotion = DiaryHelper.convertEmotionCodeToEmotion(code: AES256Util.decrypt(encoded: document.get("emotion") as? String ?? ""))
                        let imgCount = document.get("imgCount") as? Int ?? 0
                        
                        self.diaryList.append(DiaryContentsModel(title: title, contents: contents, date: date, emotion: emotion, imgCount: imgCount))
                    }
                    
                    self.diaryList.sort(by: {$0.date > $1.date})
                    
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
    
    func getEmotionList(uid: String, completion: @escaping(_ result: [StatisticsEmotionDataModel]?) -> Void){
        var emotionList: [StatisticsEmotionDataModel] = []
        var cnts = [Int](repeating: 0, count: 8)
        var emotions: [DiaryEmotionModel] = [.HAPPY, .GREAT, .GOOD, .SOSO, .BAD, .SAD, .STAY_ALONE, .ANGRY]
        
        db.collection("Diary").document(uid)
            .collection("Diaries").getDocuments(){(querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                } else{
                    if querySnapshot != nil{
                        for document in querySnapshot!.documents{
                            let data = AES256Util.decrypt(encoded: document.get("emotion") as? String ?? "")
                            
                            switch data{
                            case "HAPPY":
                                cnts[0] += 1
                                
                            case "GREAT":
                                cnts[1] += 1
                                
                            case "GOOD":
                                cnts[2] += 1
                                
                            case "SOSO":
                                cnts[3] += 1
                                
                            case "BAD":
                                cnts[4] += 1
                                
                            case "SAD":
                                cnts[5] += 1
                                
                            case "STAY_ALONE":
                                cnts[6] += 1
                                
                            case "ANGRY":
                                cnts[7] += 1
                                
                            default:
                                break
                            }
                        }
                        
                        for i in 0..<cnts.count{
                            emotionList.append(StatisticsEmotionDataModel(emotion: DiaryHelper.convertEmotionCodeToString(code: emotions[i]) ?? "", count: cnts[i]))
                        }
                    }
                }
                
                completion(emotionList)
                return
            }
    }
    
    func getEmotionStack(uid: String, completion: @escaping(_ result: [String:String]?) -> Void){
        var emotionStack: [String:String] = [:]
        
        db.collection("Diary").document(uid)
            .collection("Diaries").getDocuments(){(querySnapshot, error) in
                
                if error != nil{
                    print(error?.localizedDescription)
                } else{
                    if querySnapshot != nil{
                        for document in querySnapshot!.documents{
                            let data = AES256Util.decrypt(encoded: document.get("emotion") as? String ?? "")
                            emotionStack[document.documentID] = DiaryHelper.convertCodeToEmoji(code: DiaryHelper.convertEmotionCodeToEmotion(code: data))
                        }
                    }
                    
                    completion(emotionStack)
                    return
                }
            }
    }
    
    func getEmotionList(completion: @escaping(_ result: Bool?) -> Void){
        self.emotionStack.removeAll()
        self.emotionList.removeAll()
        
        var cnts = [Int](repeating: 0, count: 8)
        var emotions: [DiaryEmotionModel] = [.HAPPY, .GREAT, .GOOD, .SOSO, .BAD, .SAD, .STAY_ALONE, .ANGRY]
        
        db.collection("Diary").document(auth.currentUser?.uid ?? "")
            .collection("Diaries").getDocuments(){(querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                }
                
                if querySnapshot != nil{
                    for document in querySnapshot!.documents{
                        let data = AES256Util.decrypt(encoded: document.get("emotion") as? String ?? "")
                        self.emotionStack[document.documentID] = DiaryHelper.convertCodeToEmoji(code: DiaryHelper.convertEmotionCodeToEmotion(code: data))
                        
                        switch data{
                        case "HAPPY":
                            cnts[0] += 1
                            
                        case "GREAT":
                            cnts[1] += 1
                            
                        case "GOOD":
                            cnts[2] += 1
                            
                        case "SOSO":
                            cnts[3] += 1
                            
                        case "BAD":
                            cnts[4] += 1
                            
                        case "SAD":
                            cnts[5] += 1
                            
                        case "STAY_ALONE":
                            cnts[6] += 1
                            
                        case "ANGRY":
                            cnts[7] += 1
                            
                        default:
                            break
                        }
                    }
                    
                    for i in 0..<cnts.count{
                        self.emotionList.append(StatisticsEmotionDataModel(emotion: DiaryHelper.convertEmotionCodeToString(code: emotions[i]) ?? "", count: cnts[i]))
                    }
                }
                
                completion(true)
                return
            }
    }
}
