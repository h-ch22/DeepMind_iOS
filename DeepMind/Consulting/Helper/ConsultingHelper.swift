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

class ConsultingHelper: ObservableObject{
    @Published var mentorInfo: MentorInfoModel? = nil
    
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
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
                    
                    self.getMentorProfile(uid: uid){(downloadURL) in
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
    
    private func getMentorProfile(uid: String, completion: @escaping(_ result: URL?) -> Void){
        storage.reference().child("Profile/\(uid)/profile.png").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(nil)
                return
            }
            
            completion(downloadURL)
            return
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
    
    func reserveConsulting(date: String, title: String, contents: String, files: [URL], uid: String, mentorUID: String, completion: @escaping(_ result: Bool?) -> Void){
        let docRef = db.collection("Consulting").document()
        docRef.setData([
            "date": date,
            "title": AES256Util.encrypt(string: title),
            "contents": AES256Util.encrypt(string: contents),
            "fileCount": files.count,
            "uid": uid,
            "mentorUID": mentorUID
        ]){error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            if files.count > 0{
                for i in 0..<files.count{
                    let pathExtension = files[i].pathExtension
                    self.storage.reference().child("Consulting/\(docRef.documentID)\(i).\(pathExtension)")
                }
            }
        }
    }
}
