//
//  UserManagement.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

class UserManagement: ObservableObject{
    @Published var userInfo: UserInfoModel? = nil
    @Published var profile: URL? = nil
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
    func getUID() -> String{
        return auth.currentUser?.uid ?? ""
    }
    
    func signIn(email: String, password: String, completion: @escaping(_ result: Bool?) -> Void){
        auth.signIn(withEmail: email, password: password){ (_, error) in
            if error != nil{
                print(error)
                completion(false)
                return
            }
            
            self.getUserInfo(){ result in
                guard let result = result else{return}
                
                if result{
                    UserDefaults.standard.set(AES256Util.encrypt(string: email), forKey: "auth_email")
                    UserDefaults.standard.set(AES256Util.encrypt(string: password), forKey: "auth_password")
                    
                    completion(true)
                } else{
                    completion(false)
                }
            }
        }
    }
    
    func signUp(email: String, password: String, nickName: String, name: String, phone: String, birthDay: String, type: UserTypeModel, agency: String?, completion: @escaping(_ result: Bool?) -> Void){
        auth.createUser(withEmail: email, password: password){(_, error) in
            if error != nil{
                print(error)
                completion(false)
                return
            }
            
            self.db.collection("Users").document(self.auth.currentUser?.uid ?? "").setData([
                "email" : AES256Util.encrypt(string: email),
                "name" : AES256Util.encrypt(string: name),
                "nickName" : AES256Util.encrypt(string: nickName),
                "phone" : AES256Util.encrypt(string: phone),
                "birthDay" : AES256Util.encrypt(string: birthDay),
                "agency": agency != nil ? AES256Util.encrypt(string: agency!) : nil,
                "type": type.code
            ]){ error in
                if error != nil{
                    print(error)
                    
                    try? self.auth.currentUser?.delete()
                    completion(false)
                    return
                }
                
                UserDefaults.standard.set(AES256Util.encrypt(string: email), forKey: "auth_email")
                UserDefaults.standard.set(AES256Util.encrypt(string: password), forKey: "auth_password")
                completion(true)
                return
            }
        }
    }
    
    func updateNickName(nickName: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").updateData([
            "nickName": AES256Util.encrypt(string: nickName)
        ]){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            self.getUserInfo(){ result in
                guard let result = result else{return}
                completion(true)
                return
            }
        }
    }
    
    func updatePhone(phone: String, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").updateData([
            "phone": AES256Util.encrypt(string: phone)
        ]){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            self.getUserInfo(){ result in
                guard let result = result else{return}
                completion(true)
                return
            }
        }
    }
    
    func updatePassword(newPassword: String, completion: @escaping(_ result: Bool?) -> Void){
        auth.currentUser?.updatePassword(to: newPassword){ error in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            completion(true)
            return
        }
    }
    
    func updateProfile(data: UIImage, completion: @escaping(_ result: Bool?) -> Void){
        let storageRef = self.storage.reference().child("Profile/\(self.auth.currentUser?.uid ?? "")/profile.png")
        storageRef.putData(data.pngData()!, metadata: nil){ (_, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            self.getProfile(){ result in
                guard let result = result else{return}
                completion(true)
                return
            }
        }
    }
    
    func getProfile(completion: @escaping(_ result: Bool?) -> Void){
        self.storage.reference().child("Profile/\(self.auth.currentUser?.uid ?? "")/profile.png").downloadURL(){(downloadURL, error) in
            if error != nil{
                print(error?.localizedDescription)
                completion(false)
                return
            }
            
            self.profile = downloadURL
            completion(true)
            return
        }
    }
    
    func uploadFeatures(isChildAbuseAttacker: Bool, isChildAbuseVictim: Bool, isDomesticViolenceAttacker: Bool, isDomesticViolenceVictim: Bool, isPsychosis: Bool, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("FeatureInformation").document(auth.currentUser?.uid ?? "").setData([
            AES256Util.encrypt(string: "isChildAbuseAttacker") : isChildAbuseAttacker,
            AES256Util.encrypt(string: "isChildAbuseVictim") : isChildAbuseVictim,
            AES256Util.encrypt(string: "isDomesticViolenceAttacker") : isDomesticViolenceAttacker,
            AES256Util.encrypt(string: "isDomesticViolenceVictim") : isDomesticViolenceVictim,
            AES256Util.encrypt(string: "isPsychosis") : isPsychosis
        ]){ error in
            if error != nil{
                print(error)
                completion(false)
                return
            } else{
                self.getUserInfo(){ result in
                    guard let result = result else{return}
                    
                    if result{
                        completion(true)
                    } else{
                        completion(false)
                    }
                }
            }
        }
    }
    
    func getFeatures(uid: String, completion: @escaping(_ result: [Bool]?) -> Void){
        var results: [Bool] = []
        
        db.collection("FeatureInformation").document(uid).getDocument(){(document, error) in
            if error != nil{
                print(error?.localizedDescription)
            } else{
                let isChildAbuseAttacker = document?.get(FieldPath([AES256Util.encrypt(string: "isChildAbuseAttacker")]))  as? Bool ?? false
                let isChildAbuseVictim = document?.get(FieldPath([AES256Util.encrypt(string: "isChildAbuseVictim")]))  as? Bool ?? false
                let isDomesticViolenceAttacker = document?.get(FieldPath([AES256Util.encrypt(string: "isDomesticViolenceAttacker")]))  as? Bool ?? false
                let isDomesticViolenceVictim = document?.get(FieldPath([AES256Util.encrypt(string: "isDomesticViolenceAttacker")]))  as? Bool ?? false
                let isPsychosis = document?.get(FieldPath([AES256Util.encrypt(string: "isPsychosis")])) as? Bool ?? false

                results = [isChildAbuseAttacker, isChildAbuseVictim, isDomesticViolenceAttacker, isDomesticViolenceVictim, isPsychosis]
            }
            
            completion(results)
            return
        }
    }
    
    func getUserInfo(completion: @escaping(_ result: Bool?) -> Void){
        if auth.currentUser?.uid ?? "" == ""{
            completion(false)
            return
        } else{
            db.collection("Users").document(auth.currentUser?.uid ?? "").getDocument(){(document, error) in
                if error != nil{
                    print(error)
                    completion(false)
                    return
                } else{
                    if document != nil{
                        if document!.exists{
                            let UID = self.auth.currentUser?.uid ?? ""
                            let email = document!.get("email") as? String ?? ""
                            let name = document!.get("name") as? String ?? ""
                            let nickName = document!.get("nickName") as? String ?? ""
                            let phone = document!.get("phone") as? String ?? ""
                            let birthDay = document!.get("birthDay") as? String ?? ""
                            let agency = document!.get("agency") as? String ?? ""
                            let type = document!.get("type") as? String ?? ""
                            
                            self.db.collection("FeatureInformation").document(UID).getDocument(){(featureDoc, error) in
                                if error != nil{
                                    print(error)
                                    completion(false)
                                    return
                                } else{
                                    if featureDoc != nil{
                                        if featureDoc!.exists{
                                            let isChildAbuseAttacker = featureDoc!.get(FieldPath([AES256Util.encrypt(string: "isChildAbuseAttacker")])) as? Bool ?? false
                                            let isChildAbuseVictim = featureDoc!.get(FieldPath([AES256Util.encrypt(string: "isChildAbuseVictim")])) as? Bool ?? false
                                            let isDomesticViolenceAttacker = featureDoc!.get(FieldPath([AES256Util.encrypt(string: "isDomesticViolenceAttacker")])) as? Bool ?? false
                                            let isDomesticViolenceVictim = featureDoc!.get(FieldPath([AES256Util.encrypt(string: "isDomesticViolenceVictim")])) as? Bool ?? false
                                            let isPsychosis = featureDoc!.get(FieldPath([AES256Util.encrypt(string: "isPsychosis")])) as? Bool ?? false
                                            
                                            self.userInfo = UserInfoModel(UID: UID, email: email, name: name, nickName: nickName, phone: phone, birthDay: birthDay, agency: agency, type: type == "Professional" ? .PROFESSIONAL : .CUSTOMER , isChildAbuseAttacker: isChildAbuseAttacker, isChildAbuseVictim: isChildAbuseVictim, isDomesticViolenceAttacker: isDomesticViolenceAttacker, isDomesticViolenceVictim: isDomesticViolenceVictim, isPsychosis: isPsychosis)
                                            
                                            completion(true)
                                            return

                                        } else{
                                            completion(false)
                                            return
                                        }
                                    } else{
                                        completion(false)
                                        return
                                    }
                                }
                            }
                            
                        } else{
                            completion(false)
                            return
                        }
                    } else{
                        completion(false)
                        return
                    }
                }
            }
        }

    }
    
    func signOut(completion: @escaping(_ result: Bool?) -> Void){
        do{
            try auth.signOut()
        } catch{
            print(error)
            completion(false)
            return
        }
        
        UserDefaults.standard.removeObject(forKey: "auth_email")
        UserDefaults.standard.removeObject(forKey: "auth_password")
        completion(true)
        return
    }
    
    func secession(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").delete(){ error in
            if error != nil{
                print(error)
                completion(false)
                return
            } else{
                self.db.collection("FeatureInformation").document(self.auth.currentUser?.uid ?? "").delete(){ error in
                    if error != nil{
                        print(error)
                        completion(false)
                        return
                    } else{
                        do{
                            try self.auth.currentUser?.delete()
                            UserDefaults.standard.removeObject(forKey: "auth_email")
                            UserDefaults.standard.removeObject(forKey: "auth_password")
                            self.userInfo = nil
                            completion(true)
                            return
                        } catch{
                            print(error)
                            completion(false)
                            return
                        }
                    }
                }
            }
        }
    }
}
