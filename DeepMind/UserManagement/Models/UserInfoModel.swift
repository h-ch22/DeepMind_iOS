//
//  UserInfoModel.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation

struct UserInfoModel{
    let UID: String
    let email: String
    let name: String
    let nickName: String
    let phone: String
    let birthDay: String
    let agency: String?
    let type: UserTypeModel
    let isChildAbuseAttacker: Bool
    let isChildAbuseVictim: Bool
    let isDomesticViolenceAttacker: Bool
    let isDomesticViolenceVictim: Bool
    let isPsychosis: Bool
    
    init(UID: String, email: String, name: String, nickName: String, phone: String, birthDay: String, agency: String?, type: UserTypeModel, isChildAbuseAttacker: Bool, isChildAbuseVictim: Bool, isDomesticViolenceAttacker: Bool, isDomesticViolenceVictim: Bool, isPsychosis: Bool) {
        self.UID = UID
        self.email = email
        self.name = name
        self.nickName = nickName
        self.phone = phone
        self.birthDay = birthDay
        self.agency = agency
        self.type = type
        self.isChildAbuseAttacker = isChildAbuseAttacker
        self.isChildAbuseVictim = isChildAbuseVictim
        self.isDomesticViolenceAttacker = isDomesticViolenceAttacker
        self.isDomesticViolenceVictim = isDomesticViolenceVictim
        self.isPsychosis = isPsychosis
    }
}
