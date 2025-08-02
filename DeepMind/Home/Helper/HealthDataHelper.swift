//
//  HealthDataHelper.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/30/23.
//

import HealthKit
import FirebaseFirestore
import Firebase
import FirebaseAuth

class HealthDataHelper: ObservableObject{
    @Published var dayLightTime: Double = 0
    @Published var excerciseDistance: Double = 0
    @Published var dailyEmotion: String? = nil
    @Published var dailyEmotionTime: String? = nil
    @Published var emotionList: [StatisticsEmotionDataModel] = []
    @Published var emotionStack: [String: String] = [:]
    
    private let healthStore = HKHealthStore()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    private let dataToRead = Set(
        [HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
         HKObjectType.quantityType(forIdentifier: .timeInDaylight)!]
    )
    
    func requestAuthorization(completion: @escaping(_ result: Bool?) -> Void){
        self.healthStore.requestAuthorization(toShare: nil, read: dataToRead){(success, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                if success{
                    completion(true)
                    return
                } else{
                    completion(false)
                    return
                }
            }
        }
    }
    
    func updateData(){
        self.getWalkingRunningData()
        self.getDayLightTimeData()
        self.getDailyEmotion()
    }
    
    private func getWalkingRunningData(){
        guard let distanceWalkingRunningType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning) else{
            return
        }
        
        let current = Date()
        let startDate = Calendar.current.startOfDay(for: current)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: current, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceWalkingRunningType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum){(_, result, error) in
            var distance: Double = 0
            
            guard let result = result, let sum = result.sumQuantity() else{
                print("Failed to read walkingRunningData")
                return
            }
            
            distance = sum.doubleValue(for: HKUnit.meter())
            self.excerciseDistance = distance
        }
        
        healthStore.execute(query)
    }
    
    private func getDayLightTimeData(){
        guard let dayLightType = HKObjectType.quantityType(forIdentifier: .timeInDaylight) else{
            return
        }
        
        let current = Date()
        let startDate = Calendar.current.startOfDay(for: current)
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: current, options:. strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: dayLightType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum){(_, result, error) in
            var time: Double = 0
            
            guard let result = result, let sum = result.sumQuantity() else{
                print("Failed to read dayLightData")
                return
            }
            
            time = sum.doubleValue(for: HKUnit.minute())
            self.dayLightTime = time
        }
        
        healthStore.execute(query)
    }
    
    private func getDailyEmotion(){
        db.collection("Users").document(auth.currentUser?.uid ?? "")
            .collection("DailyEmotion").getDocuments(){(querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                } else{
                    if querySnapshot != nil && !querySnapshot!.isEmpty{
                        let document = querySnapshot!.documents[querySnapshot!.documents.count-1]
                        let time = document.documentID
                        let data = document.get("emotion") as? String ?? ""
                        
                        self.dailyEmotion = DiaryHelper.convertCodeToEmoji(code: DiaryHelper.convertEmotionCodeToEmotion(code: AES256Util.decrypt(encoded: document.get("emotion") as? String ?? "")))
                        self.dailyEmotionTime = time
                    }
                }
                
                return
            }
    }
    
    func getDailyEmotionList(completion: @escaping(_ result: Bool?) -> Void){
        self.emotionStack.removeAll()
        self.emotionList.removeAll()
        
        var cnts = Array(repeating: 0, count: 8)
        var emotions: [DiaryEmotionModel] = [.HAPPY, .GREAT, .GOOD, .SOSO, .BAD, .SAD, .STAY_ALONE, .ANGRY]
        
        db.collection("Users").document(auth.currentUser?.uid ?? "")
            .collection("DailyEmotion").getDocuments(){(querySnapshot, error) in
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
                        
                        for i in 0..<cnts.count{
                            self.emotionList.append(StatisticsEmotionDataModel(emotion: DiaryHelper.convertEmotionCodeToString(code: emotions[i]) ?? "", count: cnts[i]))
                        }
                    }
                }
                
                completion(true)
                return
            }
    }
    
    func uploadDailyEmotion(emotion: DiaryEmotionModel, completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"
        
        db.collection("Users").document(auth.currentUser?.uid ?? "")
            .collection("DailyEmotion").document(dateFormatter.string(from: Date())).setData([
                "emotion": AES256Util.encrypt(string: emotion.description)
            ]){error in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                }
                
                completion(true)
                return
            }
    }
    
    func getEmotionList(uid: String, completion: @escaping(_ result: [StatisticsEmotionDataModel]?) -> Void){
        var emotionList: [StatisticsEmotionDataModel] = []
        var cnts = [Int](repeating: 0, count: 8)
        var emotions: [DiaryEmotionModel] = [.HAPPY, .GREAT, .GOOD, .SOSO, .BAD, .SAD, .STAY_ALONE, .ANGRY]
        
        db.collection("Users").document(uid)
            .collection("DailyEmotion").getDocuments(){(querySnapshot, error) in
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
        
        db.collection("Users").document(uid)
            .collection("DailyEmotion").getDocuments(){(querySnapshot, error) in
                
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
}
