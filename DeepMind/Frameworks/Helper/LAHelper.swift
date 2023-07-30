//
//  LAHelper.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation
import LocalAuthentication

class LAHelper{
    func authenticate(completion : @escaping(_ result : Bool?) -> Void){
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
            let reason = "자동 로그인 기능 활성화를 위해 생체인식 권한이 필요합니다."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason){ success, error in
                if success{
                    completion(true)
                    return
                } else{
                    completion(false)
                    return
                }
            }
        } else{
            UserDefaults.standard.removeObject(forKey: "auth_email")
            UserDefaults.standard.removeObject(forKey: "auth_password")
            completion(false)
            return
        }
    }
    
    static func getDeviceType() -> LABiometryType{
        let context = LAContext()
        
        let _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
        
        switch(context.biometryType){
        case .none:
            return .none
            
        case .faceID:
            return .faceID
            
        case .touchID:
            return .touchID
        }
    }
}
