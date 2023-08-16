//
//  DailyEmotionHelper.swift
//  DeepMind
//
//  Created by 하창진 on 8/16/23.
//

import Foundation
import Firebase

class DailyEmotionHelper : ObservableObject{
    @Published var dailyEmotion: DiaryEmotionModel? = nil
    @Published var emotions: [DiaryEmotionModel] = []
    @Published var diaryEmotions: [DiaryEmotionModel] = []
    
    @Published var dailyEmotionStatistics: [StatisticsEmotionDataModel] = [StatisticsEmotionDataModel(emotion: "🥰 행복해요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😆 최고예요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😀 좋아요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "🙂 그저그래요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "☹️ 안좋아요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😢 슬퍼요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😣 혼자있고싶어요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😡 화나요", count: 0)]
    
    @Published var diaryEmotionStatistics: [StatisticsEmotionDataModel] = [StatisticsEmotionDataModel(emotion: "🥰 행복해요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😆 최고예요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😀 좋아요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "🙂 그저그래요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "☹️ 안좋아요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😢 슬퍼요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😣 혼자있고싶어요", count: 0),
                                                                            StatisticsEmotionDataModel(emotion: "😡 화나요", count: 0)]
    
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    private let dateFormatter = DateFormatter()

    func getDailyEmotion(completion: @escaping(_ result: Bool?) -> Void){
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("DailyEmotion").document(dateFormatter.string(from: Date())).getDocument(){(document, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                let emotion = document?.get("emotion") as? String ?? ""
                self.dailyEmotion = DiaryHelper.convertEmotionCodeToEmotion(code: AES256Util.decrypt(encoded: emotion))
                
                completion(true)
                return
            }
        }
    }
    
    func uploadDailyEmotion(emotion: DiaryEmotionModel, completion: @escaping(_ result: Bool?) -> Void){
        dateFormatter.dateFormat = "yyyy. MM. dd."

        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("DailyEmotion").document(dateFormatter.string(from: Date())).setData(["emotion": AES256Util.encrypt(string: emotion.description)]){error in
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
    
    func getAllEmotions(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").collection("DailyEmotion").getDocuments(){(documentSnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                for document in documentSnapshot!.documents{
                    let emotion = document.data()["emotion"] as? String ?? ""
                    
                    if emotion != ""{
                        let emotionAsCode = DiaryHelper.convertEmotionCodeToEmotion(code: AES256Util.decrypt(encoded: emotion))
                        
                        self.dailyEmotionStatistics[emotionAsCode.code].count += 1
                    }
                }
                
                self.db.collection("Diary").document(self.auth.currentUser?.uid ?? "").collection("Diaries").getDocuments(){(documentSnapshot, error) in
                    if error != nil{
                        print(error?.localizedDescription)
                        completion(false)
                        return
                    } else{
                        for document in documentSnapshot!.documents{
                            let emotion = document.data()["emotion"] as? String ?? ""
                            
                            if emotion != ""{
                                let emotionAsCode = DiaryHelper.convertEmotionCodeToEmotion(code: AES256Util.decrypt(encoded: emotion))
                                self.diaryEmotionStatistics[emotionAsCode.code].count += 1
                            }
                        }
                    }
                }
                
                completion(true)
                return
            }
        }
    }
}
