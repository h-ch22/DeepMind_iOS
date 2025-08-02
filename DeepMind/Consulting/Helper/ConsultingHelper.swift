//
//  ConsultingHelper.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import Firebase
import FirebaseAuth

class ConsultingHelper: ObservableObject{
    @Published var mentorInfo: MentorInfoModel? = nil
    @Published var menteeInfo: MentorInfoModel? = nil
    @Published var mentors: [MentorInfoModel] = []
    @Published var reservationList: [ConsultingDataModel] = []
    @Published var unratedReservationList: [ConsultingDataModel] = []
    @Published var allReservationList: [ConsultingDataModel] = []
    @Published var imgList: [URL] = []
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    private let auth = Auth.auth()
    
    func getMentorInfo(uid: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(uid).getDocument(){(document, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                if document != nil{
                    let name = document?.get("name") as? String ?? ""
                    let hospitalLocation = document?.get("hospitalLocation") as? String ?? ""
                    let hospitalAddress = document?.get("hospitalAddress") as? String ?? ""
                    let rate = document?.get("rate") as? Double ?? 0.0
                    
                    var _hospitalLocation: [Substring] = []
                    
                    if hospitalLocation.contains(", "){
                        _hospitalLocation = hospitalLocation.split(separator: ", ")
                    }
                    
                    self.getProfile(uid: uid){(downloadURL) in
                        self.mentorInfo = MentorInfoModel(mentorUID: uid,
                                                          mentorName: AES256Util.decrypt(encoded: name),
                                                          mentorProfile: downloadURL,
                                                          hospitalLocation: hospitalLocation.contains(", ") ? [
                                                            Double(_hospitalLocation[0]) ?? 0.0,
                                                            Double(_hospitalLocation[1]) ?? 0.0
                                                          ] : nil,
                                                          hospitalAddress: hospitalAddress,
                                                          rate: rate)
                        
                        completion(true)
                        return
                    }
                } else{
                    completion(false)
                    return
                }
            }
        }
    }
    
    func getMenteeInfo(uid: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(uid).getDocument(){(document, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                if document != nil{
                    let name = document?.get("name") as? String ?? ""
                    let hospitalLocation = document?.get("hospitalLocation") as? String ?? ""
                    let hospitalAddress = document?.get("hospitalAddress") as? String ?? ""
                    let rate = document?.get("rate") as? Double ?? 0.0
                    
                    var _hospitalLocation: [Substring] = []
                    
                    if hospitalLocation.contains(", "){
                        _hospitalLocation = hospitalLocation.split(separator: ", ")
                    }
                    
                    self.getProfile(uid: uid){(downloadURL) in
                        self.menteeInfo = MentorInfoModel(mentorUID: uid,
                                                          mentorName: AES256Util.decrypt(encoded: name),
                                                          mentorProfile: downloadURL,
                                                          hospitalLocation: hospitalLocation.contains(", ") ? [
                                                            Double(_hospitalLocation[0]) ?? 0.0,
                                                            Double(_hospitalLocation[1]) ?? 0.0
                                                          ] : nil,
                                                          hospitalAddress: hospitalAddress,
                                                          rate: rate)
                        
                        completion(true)
                        return
                    }
                } else{
                    completion(false)
                    return
                }
            }
        }
    }
    
    func getProfile(uid: String, completion: @escaping(_ result: URL?) -> Void){
        storage.reference().child("Profile/\(uid)/profile.png").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
            }
            
            completion(downloadURL)
        }
    }
    
    func uploadHospitalInformation(uid: String, location: String, address: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(uid).updateData([
            "hospitalLocation": location,
            "hospitalAddress": address
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
    
    func reserveConsulting(mentorName: String, menteeName: String, date: String, time: String, message: String, type: ConsultingMethodType, images: [UIImage], uid: String, mentorUID: String, completion: @escaping(_ result: Bool?) -> Void){
        let docRef = db.collection("Consulting").document()
        docRef.setData([
            "date": date,
            "time": "\(time):00",
            "message": AES256Util.encrypt(string: message),
            "type": type == .INTERVIEW ? "INTERVIEW" : "CHAT",
            "imageCount": images.count,
            "uid": uid,
            "mentorUID": mentorUID,
            "mentorName": AES256Util.encrypt(string: mentorName),
            "menteeName": AES256Util.encrypt(string: menteeName)
        ]){error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if images.count > 0{
                for i in 0..<images.count{
                    let storageRef = self.storage.reference().child("Consulting/\(docRef.documentID)/\(i).png")
                    storageRef.putData(images[i].pngData()!){_, error in
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
                
                completion(true)
                return
            }
        }
    }
    
    func getReservationList(uid: String, date: String, completion: @escaping(_ result: [String]?) -> Void){
        var reservationTimes: [String] = []
        
        let docRef = db.collection("Consulting")
            .whereField("mentorUID", isEqualTo: uid)
            .whereField("date", isEqualTo: date)
            .getDocuments(){(querySnapshot, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(reservationTimes)
                    return
                } else if querySnapshot != nil{
                    for document in querySnapshot!.documents{
                        let time = document.get("time") as? String ?? ""
                        
                        reservationTimes.append(time)
                    }
                    
                    completion(reservationTimes)
                    return
                } else{
                    completion(reservationTimes)
                    return
                }
            }
    }
    
    func getReservationList(completion: @escaping(_ result: Bool?) -> Void){
        self.reservationList.removeAll()
        self.unratedReservationList.removeAll()
        self.allReservationList.removeAll()
        
        db.collection("Consulting").whereField("mentorUID", isEqualTo: auth.currentUser?.uid ?? "").getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    let id = document.documentID
                    let message = document.get("message") as? String ?? ""
                    let date = document.get("date") as? String ?? ""
                    let time = document.get("time") as? String ?? ""
                    let mentorUID = document.get("mentorUID") as? String ?? ""
                    let imageIndex = document.get("imageCount") as? Int ?? 0
                    let type = document.get("type") as? String ?? ""
                    let mentorName = document.get("mentorName") as? String ?? ""
                    let menteeUID = document.get("uid") as? String ?? ""
                    let menteeName = document.get("menteeName") as? String ?? ""

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy. MM. dd."
                    
                    let current = dateFormatter.date(from: dateFormatter.string(from: Date()))
                    let reservationDate = dateFormatter.date(from: date)
                    
                    self.getProfile(uid: menteeUID){ result in
                        
                        if current! < reservationDate!{
                            self.reservationList.append(ConsultingDataModel(id: id, message: AES256Util.decrypt(encoded: message), date: date, time: time, mentorUID: mentorUID, imageIndex: imageIndex, type: type == "INTERVIEW" ? .INTERVIEW : .CHAT, mentorName: AES256Util.decrypt(encoded: mentorName), mentorProfile: result, menteeUID: menteeUID, menteeName: AES256Util.decrypt(encoded: menteeName)))
                            self.reservationList.sort(by: {$0.date < $1.date})
                        }else{
                            let isRated = document.get("isProRated") as? Bool ?? false
                            
                            if !isRated{
                                self.unratedReservationList.append(ConsultingDataModel(id: id, message: AES256Util.decrypt(encoded: message), date: date, time: time, mentorUID: mentorUID, imageIndex: imageIndex, type: type == "INTERVIEW" ? .INTERVIEW : .CHAT, mentorName: AES256Util.decrypt(encoded: mentorName), mentorProfile: result, menteeUID: menteeUID, menteeName: AES256Util.decrypt(encoded: menteeName)))
                                self.unratedReservationList.sort(by: {$0.date < $1.date})
                            }
                        }
                        
                        self.allReservationList.append(ConsultingDataModel(id: id, message: AES256Util.decrypt(encoded: message), date: date, time: time, mentorUID: mentorUID, imageIndex: imageIndex, type: type == "INTERVIEW" ? .INTERVIEW : .CHAT, mentorName: AES256Util.decrypt(encoded: mentorName), mentorProfile: result, menteeUID: menteeUID, menteeName: AES256Util.decrypt(encoded: menteeName)))
                        self.allReservationList.sort(by: {$0.date < $1.date})
                    }
                }
            }
            
            completion(true)
            return
        }
    }
    
    func getReservationList(uid: String, completion: @escaping(_ result: Bool?) -> Void){
        self.reservationList.removeAll()
        self.unratedReservationList.removeAll()
        self.allReservationList.removeAll()
        
        db.collection("Consulting").whereField("uid", isEqualTo: uid).getDocuments(){(querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    let id = document.documentID
                    let message = document.get("message") as? String ?? ""
                    let date = document.get("date") as? String ?? ""
                    let time = document.get("time") as? String ?? ""
                    let mentorUID = document.get("mentorUID") as? String ?? ""
                    let imageIndex = document.get("imageCount") as? Int ?? 0
                    let type = document.get("type") as? String ?? ""
                    let mentorName = document.get("mentorName") as? String ?? ""
                    let menteeUID = document.get("uid") as? String ?? ""
                    let menteeName = document.get("menteeName") as? String ?? ""

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy. MM. dd."
                    
                    let current = dateFormatter.date(from: dateFormatter.string(from: Date()))
                    let reservationDate = dateFormatter.date(from: date)
                    
                    self.getProfile(uid: mentorUID){ result in
                        
                        if current! < reservationDate!{
                            self.reservationList.append(ConsultingDataModel(id: id, message: AES256Util.decrypt(encoded: message), date: date, time: time, mentorUID: mentorUID, imageIndex: imageIndex, type: type == "INTERVIEW" ? .INTERVIEW : .CHAT, mentorName: AES256Util.decrypt(encoded: mentorName), mentorProfile: result, menteeUID: menteeUID, menteeName: AES256Util.decrypt(encoded: menteeName)))
                            self.reservationList.sort(by: {$0.date < $1.date})
                        } else{
                            let isRated = document.get("isRated") as? Bool ?? false
                            
                            if !isRated{
                                self.unratedReservationList.append(ConsultingDataModel(id: id, message: AES256Util.decrypt(encoded: message), date: date, time: time, mentorUID: mentorUID, imageIndex: imageIndex, type: type == "INTERVIEW" ? .INTERVIEW : .CHAT, mentorName: AES256Util.decrypt(encoded: mentorName), mentorProfile: result, menteeUID: menteeUID, menteeName: AES256Util.decrypt(encoded: menteeName)))
                                self.unratedReservationList.sort(by: {$0.date < $1.date})
                            }
                        }
                        
                        self.allReservationList.append(ConsultingDataModel(id: id, message: AES256Util.decrypt(encoded: message), date: date, time: time, mentorUID: mentorUID, imageIndex: imageIndex, type: type == "INTERVIEW" ? .INTERVIEW : .CHAT, mentorName: AES256Util.decrypt(encoded: mentorName), mentorProfile: result, menteeUID: menteeUID, menteeName: AES256Util.decrypt(encoded: menteeName)))
                        self.allReservationList.sort(by: {$0.date < $1.date})
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
    
    func downloadImages(id: String, imageCount: Int, completion: @escaping(_ result: Bool?) -> Void){
        self.imgList.removeAll()
        
        for i in 0..<imageCount{
            self.storage.reference().child("Consulting/\(id)/\(i).png").downloadURL(){(downloadURL, error) in
                if error != nil{
                    print(error?.localizedDescription)
                    completion(false)
                    return
                } else if downloadURL != nil{
                    self.imgList.append(downloadURL!)
                }
            }
        }
        
        completion(true)
        return
    }
    
    func cancelConsulting(id: String, imageCount: Int, completion: @escaping(_ result: Bool?) -> Void){
        self.db.collection("Consulting").document(id).delete(){error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else{
                for i in 0..<imageCount{
                    self.storage.reference().child("Consulting/\(id)/\(i).png").delete(){_ in
                        
                    }
                }
                
                completion(true)
                return
            }
        }
    }
    
    func getAllMentors(completion: @escaping(_ result: Bool?) -> Void){
        self.mentors.removeAll()
        
        self.db.collection("Users").whereField("type", isEqualTo: "Professional").getDocuments(){ (querySnapshot, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            } else if querySnapshot != nil{
                for document in querySnapshot!.documents{
                    let uid = document.documentID
                    let name = document.get("name") as? String ?? ""
                    let hospitalLocation = document.get("hospitalLocation") as? String ?? ""
                    let hospitalAddress = document.get("hospitalAddress") as? String ?? ""
                    let rate = document.get("rate") as? Double ?? 0.0
                    
                    var hospitalCoord: [Double]? = []
                    
                    if hospitalLocation.contains(", "){
                        let coord = hospitalLocation.split(separator: ", ")
                        hospitalCoord?.append(Double(coord[0]) ?? 0.0)
                        hospitalCoord?.append(Double(coord[1]) ?? 0.0)
                    }
                    
                    self.getProfile(uid: uid){ result in
                        self.mentors.append(
                            MentorInfoModel(mentorUID: uid, mentorName: AES256Util.decrypt(encoded: name), mentorProfile: result, hospitalLocation: hospitalCoord == nil ? nil : hospitalCoord, hospitalAddress: hospitalAddress, rate: rate)
                        )
                        
                        print(self.mentors)
                        
                        if self.mentors.count == querySnapshot!.documents.count{
                            completion(true)
                            return
                        }
                    }
                }
            } else{
                completion(false)
                return
            }
        }
    }
}
