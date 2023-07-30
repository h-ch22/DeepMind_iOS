//
//  UserManagement.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserManagement: ObservableObject{
    @Published var userInfo: UserInfoModel? = nil
    
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
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
    
    func signUp(email: String, password: String, nickName: String, name: String, phone: String, birthDay: String, completion: @escaping(_ result: Bool?) -> Void){
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
                "birthDay" : AES256Util.encrypt(string: birthDay)
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
    
    func uploadFeatures(isChildAbuseAttacker: Bool, isChildAbuseVictim: Bool, isDomesticViolenceAttacker: Bool, isDomesticViolenceVictim: Bool, isPsychosis: Bool, completion: @escaping(_ result: Bool?) -> Void){
        db.collection("FeatureInformation").document(AES256Util.encrypt(string: auth.currentUser?.uid ?? "")).setData([
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
    
    func getUserInfo(completion: @escaping(_ result: Bool?) -> Void){
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
                        
                        self.db.collection("FeatureInformation").document(AES256Util.encrypt(string: UID)).getDocument(){(featureDoc, error) in
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
                                        
                                        self.userInfo = UserInfoModel(UID: UID, email: email, name: name, nickName: nickName, phone: phone, birthDay: birthDay, isChildAbuseAttacker: isChildAbuseAttacker, isChildAbuseVictim: isChildAbuseVictim, isDomesticViolenceAttacker: isDomesticViolenceAttacker, isDomesticViolenceVictim: isDomesticViolenceVictim, isPsychosis: isPsychosis)
                                        
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
    
    func signOut(completion: @escaping(_ result: Bool?) -> Void){
        do{
            try? auth.signOut()
            completion(true)
            return
        } catch{
            print(error)
            completion(false)
            return
        }
    }
    
    func secession(completion: @escaping(_ result: Bool?) -> Void){
        db.collection("Users").document(auth.currentUser?.uid ?? "").delete(){ error in
            if error != nil{
                print(error)
                completion(false)
                return
            } else{
                self.db.collection("FeatureInformation").document(AES256Util.encrypt(string: self.auth.currentUser?.uid ?? "")).delete(){ error in
                    if error != nil{
                        print(error)
                        completion(false)
                        return
                    } else{
                        do{
                            try? self.auth.currentUser?.delete()
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
