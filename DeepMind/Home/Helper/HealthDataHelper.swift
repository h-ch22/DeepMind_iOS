//
//  HealthDataHelper.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/30/23.
//

import HealthKit
import FirebaseFirestore
import Firebase

class HealthDataHelper: ObservableObject{
    @Published var dayLightTime: Double = 0
    @Published var excerciseDistance: Double = 0
    @Published var dailyEmotion: DiaryEmotionModel? = nil
    @Published var dailyEmotionTime: String? = nil
    
    private let healthStore = HKHealthStore()
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    private let dataToRead = Set(
        [HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
         HKObjectType.quantityType(forIdentifier: .timeInDaylight)!
        ])
    
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
            .collection("DailyEmotion").limit(to: 1).getDocuments(){(querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    return
                } else{
                    for document in querySnapshot!.documents{
                        let time = document.documentID
                        let data = document.get("emotion") as? String ?? ""
                        
                        self.dailyEmotion = DiaryHelper.convertEmotionCodeToEmotion(code: data)
                        self.dailyEmotionTime = time
                    }
                }
            }
    }
    
    func uploadDailyEmotion(emotion: DiaryEmotionModel, completion: @escaping(_ result: Bool?) -> Void){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd. kk:mm:ss"
        
        db.collection("Users").document(auth.currentUser?.uid ?? "")
            .collection("DailyEmotion").document(dateFormatter.string(from: Date())).setData([
                "emotion": DiaryHelper.convertEmotionCodeToString(code: emotion)
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
}
