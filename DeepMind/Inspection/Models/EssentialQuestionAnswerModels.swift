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
    var ANSWER_09: HouseReferenceModel? = nil
    var ANSWER_10: PersonGenderModel? = nil
    var ANSWER_11: Bool? = nil
    var ANSWER_12: Bool? = nil
    var ANSWER_13: Bool? = nil
    var ANSWER_14: Bool? = nil
    
    init(ANSWER_01: Bool? = nil, ANSWER_02: Bool? = nil, ANSWER_03: HouseWeatherModel? = nil, ANSWER_04: Bool? = nil, ANSWER_05: Int? = nil, ANSWER_06: Bool? = nil, ANSWER_07: Int? = nil, ANSWER_08: Bool? = nil, ANSWER_09: HouseReferenceModel? = nil, ANSWER_10: PersonGenderModel? = nil, ANSWER_11: Bool? = nil, ANSWER_12: Bool? = nil, ANSWER_13: Bool? = nil, ANSWER_14: Bool? = nil) {
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
}
