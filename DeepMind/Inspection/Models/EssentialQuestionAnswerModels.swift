//
//  EssentialQuestionAnswerModels.swift
//  DeepMind
//
//  Created by 하창진 on 8/17/23.
//

import Foundation

struct HouseEssentialQuestionAnswerModel{
    var ANSWER_01: Bool? = nil
    var ANSWER_02: Bool? = nil
    var ANSWER_03: HouseWeatherModel? = nil
    var ANSWER_04: Bool? = nil
    var ANSWER_05: Int? = nil
    var ANSWER_06: HouseFamilyTypeModel? = nil
    var ANSWER_07: HouseAtmosphereModel? = nil
    var ANSWER_08: HouseInspirationModel? = nil
    var ANSWER_09: HouseRoomModel? = nil
    var ANSWER_10: HouseInspirationModel? = nil
    var ANSWER_11: Bool? = nil
    var ANSWER_12: HouseReferenceModel? = nil
    var ANSWER_13: Bool? = nil
    var ANSWER_14: Bool? = nil
    
    init(ANSWER_01: Bool? = nil, ANSWER_02: Bool? = nil, ANSWER_03: HouseWeatherModel? = nil, ANSWER_04: Bool? = nil, ANSWER_05: Int? = nil, ANSWER_06: HouseFamilyTypeModel? = nil, ANSWER_07: HouseAtmosphereModel? = nil, ANSWER_08: HouseInspirationModel? = nil, ANSWER_09: HouseRoomModel? = nil, ANSWER_10: HouseInspirationModel? = nil, ANSWER_11: Bool? = nil, ANSWER_12: HouseReferenceModel? = nil, ANSWER_13: Bool? = nil, ANSWER_14: Bool? = nil) {
        self.ANSWER_01 = ANSWER_01
        self.ANSWER_02 = ANSWER_02
        self.ANSWER_03 = ANSWER_03
        self.ANSWER_04 = ANSWER_04
        self.ANSWER_05 = ANSWER_05
        self.ANSWER_06 = ANSWER_06
        self.ANSWER_07 = ANSWER_07
        self.ANSWER_08 = ANSWER_08
        self.ANSWER_09 = ANSWER_09
        self.ANSWER_10 = ANSWER_10
        self.ANSWER_11 = ANSWER_11
        self.ANSWER_12 = ANSWER_12
        self.ANSWER_13 = ANSWER_13
        self.ANSWER_14 = ANSWER_14
    }
    
    func getAnswer(index: Int) -> String{
        switch index{
        case 0:
            return (ANSWER_01 ?? true) ? "예" : "아니오"
            
        case 1:
            return (ANSWER_02 ?? true) ? "예" : "아니오"
        
        case 2:
            return ANSWER_03?.description ?? "맑음"
            
        case 3:
            return (ANSWER_04 ?? true) ? "예" : "아니오"
            
        case 4:
            return "\(String(ANSWER_05 ?? 0))명"
            
        case 5:
            return ANSWER_06?.description ?? "친절한"
            
        case 6:
            return ANSWER_07?.description ?? "화목한"
            
        case 7:
            return ANSWER_08?.description ?? "부모"
            
        case 8:
            return ANSWER_09?.description ?? "큰 방"
            
        case 9:
            return ANSWER_10?.description ?? "부모"
            
        case 10:
            return (ANSWER_11 ?? true) ? "예" : "아니오"
            
        case 11:
            return ANSWER_12?.description ?? "부모"
            
        case 12:
            return (ANSWER_13 ?? true) ? "예" : "아니오"
            
        case 13:
            return (ANSWER_14 ?? true) ? "예" : "아니오"
            
        default:
            return ""
        }
    }
}

struct TreeEssentialQuestionAnswerModel{
    var ANSWER_01: Bool? = nil
    var ANSWER_02: Bool? = nil
    var ANSWER_03: HouseWeatherModel? = nil
    var ANSWER_04: Bool? = nil
    var ANSWER_05: Int? = nil
    var ANSWER_06: Bool? = nil
    var ANSWER_07: Int? = nil
    var ANSWER_08: Bool? = nil
    var ANSWER_09: HouseInspirationModel? = nil
    var ANSWER_10: PersonGenderModel? = nil
    var ANSWER_11: Bool? = nil
    var ANSWER_12: Bool? = nil
    var ANSWER_13: Bool? = nil
    var ANSWER_14: Bool? = nil
    
    init(ANSWER_01: Bool? = nil, ANSWER_02: Bool? = nil, ANSWER_03: HouseWeatherModel? = nil, ANSWER_04: Bool? = nil, ANSWER_05: Int? = nil, ANSWER_06: Bool? = nil, ANSWER_07: Int? = nil, ANSWER_08: Bool? = nil, ANSWER_09: HouseInspirationModel? = nil, ANSWER_10: PersonGenderModel? = nil, ANSWER_11: Bool? = nil, ANSWER_12: Bool? = nil, ANSWER_13: Bool? = nil, ANSWER_14: Bool? = nil) {
        self.ANSWER_01 = ANSWER_01
        self.ANSWER_02 = ANSWER_02
        self.ANSWER_03 = ANSWER_03
        self.ANSWER_04 = ANSWER_04
        self.ANSWER_05 = ANSWER_05
        self.ANSWER_06 = ANSWER_06
        self.ANSWER_07 = ANSWER_07
        self.ANSWER_08 = ANSWER_08
        self.ANSWER_09 = ANSWER_09
        self.ANSWER_10 = ANSWER_10
        self.ANSWER_11 = ANSWER_11
        self.ANSWER_12 = ANSWER_12
        self.ANSWER_13 = ANSWER_13
        self.ANSWER_14 = ANSWER_14
    }
    
    func getAnswer(index: Int) -> String{
        switch index{
        case 0:
            return (ANSWER_01 ?? true) ? "예" : "아니오"
            
        case 1:
            return (ANSWER_02 ?? true) ? "예" : "아니오"
            
        case 2:
            return ANSWER_03?.description ?? "맑음"
            
        case 3:
            return (ANSWER_04 ?? true) ? "예" : "아니오"
            
        case 4:
            return String(ANSWER_05 ?? 0) + "년"
            
        case 5:
            return (ANSWER_06 ?? true) ? "예" : "아니오"
            
        case 6:
            return String(ANSWER_07 ?? 0) + "년 전"
            
        case 7:
            return (ANSWER_08 ?? true) ? "예" : "아니오"
            
        case 8:
            return ANSWER_09?.description ?? "부모"
            
        case 9:
            return ANSWER_10?.description ?? "남자"
            
        case 10:
            return (ANSWER_11 ?? true) ? "예" : "아니오"
            
        case 11:
            return (ANSWER_12 ?? true) ? "예" : "아니오"
            
        case 12:
            return (ANSWER_13 ?? true) ? "예" : "아니오"
            
        case 13:
            return (ANSWER_14 ?? true) ? "예" : "아니오"
            
        default:
            return ""
        }
    }
}

struct PersonEssentialQuestionAnswerModel{
    var ANSWER_01: Int? = nil
    var ANSWER_02: Bool? = nil
    var ANSWER_03: Int? = nil
    var ANSWER_04: HouseFamilyTypeModel? = nil
    var ANSWER_05: Bool? = nil
    var ANSWER_06: Bool? = nil
    var ANSWER_07: HouseFamilyTypeModel? = nil
    var ANSWER_08: HouseFamilyTypeModel? = nil
    var ANSWER_09: Bool? = nil
    var ANSWER_10: Bool? = nil
    var ANSWER_11: Bool? = nil
    var ANSWER_12: Bool? = nil
    var ANSWER_13: Bool? = nil
    var ANSWER_14: HouseReferenceModel? = nil
    var ANSWER_15: HouseReferenceModel? = nil
    
    init(ANSWER_01: Int? = nil, ANSWER_02: Bool? = nil, ANSWER_03: Int? = nil, ANSWER_04: HouseFamilyTypeModel? = nil, ANSWER_05: Bool? = nil, ANSWER_06: Bool? = nil, ANSWER_07: HouseFamilyTypeModel? = nil, ANSWER_08: HouseFamilyTypeModel? = nil, ANSWER_09: Bool? = nil, ANSWER_10: Bool? = nil, ANSWER_11: Bool? = nil, ANSWER_12: Bool? = nil, ANSWER_13: Bool? = nil, ANSWER_14: HouseReferenceModel? = nil, ANSWER_15: HouseReferenceModel? = nil) {
        self.ANSWER_01 = ANSWER_01
        self.ANSWER_02 = ANSWER_02
        self.ANSWER_03 = ANSWER_03
        self.ANSWER_04 = ANSWER_04
        self.ANSWER_05 = ANSWER_05
        self.ANSWER_06 = ANSWER_06
        self.ANSWER_07 = ANSWER_07
        self.ANSWER_08 = ANSWER_08
        self.ANSWER_09 = ANSWER_09
        self.ANSWER_10 = ANSWER_10
        self.ANSWER_11 = ANSWER_11
        self.ANSWER_12 = ANSWER_12
        self.ANSWER_13 = ANSWER_13
        self.ANSWER_14 = ANSWER_14
        self.ANSWER_15 = ANSWER_15
    }
    
    func getAnswer(index: Int) -> String{
        switch index{
        case 0:
            return "\(String(ANSWER_01 ?? 0))세"
            
        case 1:
            return (ANSWER_02 ?? true) ? "예" : "아니오"
            
        case 2:
            return String(ANSWER_03 ?? 0) + "명"
            
        case 3:
            return ANSWER_04?.description ?? "친절한"
            
        case 4:
            return (ANSWER_05 ?? true) ? "예" : "아니오"
            
        case 5:
            return (ANSWER_06 ?? true) ? "예" : "아니오"
            
        case 6:
            return ANSWER_07?.description ?? "친절한"
            
        case 7:
            return ANSWER_08?.description ?? "친절한"
            
        case 8:
            return (ANSWER_09 ?? true) ? "예" : "아니오"
            
        case 9:
            return (ANSWER_10 ?? true) ? "예" : "아니오"
            
        case 10:
            return (ANSWER_11 ?? true) ? "예" : "아니오"
            
        case 11:
            return (ANSWER_12 ?? true) ? "예" : "아니오"
            
        case 12:
            return (ANSWER_13 ?? true) ? "예" : "아니오"
            
        case 13:
            return ANSWER_14?.description ?? "부모"
            
        case 14:
            return ANSWER_15?.description ?? "친절한"
            
        default:
            return ""
        }
    }
}
