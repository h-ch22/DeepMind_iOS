//
//  TreeResultModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import Foundation

struct TreeResultModel{
    var energeticBeing: InspectionSeverityModel
    var haveFeelingsThatBeingDriven: InspectionSeverityModel
    var closed: InspectionSeverityModel
    var inferior: InspectionSeverityModel
    var signsOfMaladjustment: InspectionSeverityModel
    var strongSensitivity: InspectionSeverityModel
    var lackOfWarmth: InspectionSeverityModel
    var pathologicalSigns: InspectionSeverityModel
    var actAggressively: InspectionSeverityModel
    var helplessness: InspectionSeverityModel
    var inflexiblePersonality: InspectionSeverityModel
    var slow: InspectionSeverityModel
    var strongFixationOnPast: InspectionSeverityModel
    var disbeliefInExtraterestrials: InspectionSeverityModel
    var pressure: InspectionSeverityModel
    var psychologicalTrauma: InspectionSeverityModel
    var highEnergy: InspectionSeverityModel
    var lowEnergy: InspectionSeverityModel
    var interestExpands: InspectionSeverityModel
    var depressed: InspectionSeverityModel
    var richSensitivity: InspectionSeverityModel
    var extroversion: InspectionSeverityModel
    var intellignece: InspectionSeverityModel
    var selfImprovement: InspectionSeverityModel
    var strongCriticism: InspectionSeverityModel
    var easyEmotions: InspectionSeverityModel
    var notSeekSatisfaction: InspectionSeverityModel
    var tryingToGetSatisfaction: InspectionSeverityModel
    var incompetence: InspectionSeverityModel
    var loveCraving: InspectionSeverityModel
    var interestInFamily: InspectionSeverityModel
    var grownIndependently: InspectionSeverityModel
    var lossOfLivelihood: InspectionSeverityModel
    var realityVerification: InspectionSeverityModel
    var instability: InspectionSeverityModel
    var immaturity: InspectionSeverityModel
    var strongDesireForStability: InspectionSeverityModel
    var lossOfSelfConttrol: InspectionSeverityModel
    var helpless: InspectionSeverityModel
    var face: InspectionSeverityModel
    var feelingRejected: InspectionSeverityModel
    var stonglyConscious: InspectionSeverityModel
    var resistive: InspectionSeverityModel
    var successiveBeats: InspectionSeverityModel
    var dependentOnOthers: InspectionSeverityModel
    var calm: InspectionSeverityModel
    
    init(energeticBeing: InspectionSeverityModel, haveFeelingsThatBeingDriven: InspectionSeverityModel, closed: InspectionSeverityModel, inferior: InspectionSeverityModel, signsOfMaladjustment: InspectionSeverityModel, strongSensitivity: InspectionSeverityModel, lackOfWarmth: InspectionSeverityModel, pathologicalSigns: InspectionSeverityModel, actAggressively: InspectionSeverityModel, helplessness: InspectionSeverityModel, inflexiblePersonality: InspectionSeverityModel, slow: InspectionSeverityModel, strongFixationOnPast: InspectionSeverityModel, disbeliefInExtraterestrials: InspectionSeverityModel, pressure: InspectionSeverityModel, psychologicalTrauma: InspectionSeverityModel, highEnergy: InspectionSeverityModel, lowEnergy: InspectionSeverityModel, interestExpands: InspectionSeverityModel, depressed: InspectionSeverityModel, richSensitivity: InspectionSeverityModel, extroversion: InspectionSeverityModel, intellignece: InspectionSeverityModel, selfImprovement: InspectionSeverityModel, strongCriticism: InspectionSeverityModel, easyEmotions: InspectionSeverityModel, notSeekSatisfaction: InspectionSeverityModel, tryingToGetSatisfaction: InspectionSeverityModel, incompetence: InspectionSeverityModel, loveCraving: InspectionSeverityModel, interestInFamily: InspectionSeverityModel, grownIndependently: InspectionSeverityModel, lossOfLivelihood: InspectionSeverityModel, realityVerification: InspectionSeverityModel, instability: InspectionSeverityModel, immaturity: InspectionSeverityModel, strongDesireForStability: InspectionSeverityModel, lossOfSelfConttrol: InspectionSeverityModel, helpless: InspectionSeverityModel, face: InspectionSeverityModel, feelingRejected: InspectionSeverityModel, stonglyConscious: InspectionSeverityModel, resistive: InspectionSeverityModel, successiveBeats: InspectionSeverityModel, dependentOnOthers: InspectionSeverityModel, calm: InspectionSeverityModel) {
        self.energeticBeing = energeticBeing
        self.haveFeelingsThatBeingDriven = haveFeelingsThatBeingDriven
        self.closed = closed
        self.inferior = inferior
        self.signsOfMaladjustment = signsOfMaladjustment
        self.strongSensitivity = strongSensitivity
        self.lackOfWarmth = lackOfWarmth
        self.pathologicalSigns = pathologicalSigns
        self.actAggressively = actAggressively
        self.helplessness = helplessness
        self.inflexiblePersonality = inflexiblePersonality
        self.slow = slow
        self.strongFixationOnPast = strongFixationOnPast
        self.disbeliefInExtraterestrials = disbeliefInExtraterestrials
        self.pressure = pressure
        self.psychologicalTrauma = psychologicalTrauma
        self.highEnergy = highEnergy
        self.lowEnergy = lowEnergy
        self.interestExpands = interestExpands
        self.depressed = depressed
        self.richSensitivity = richSensitivity
        self.extroversion = extroversion
        self.intellignece = intellignece
        self.selfImprovement = selfImprovement
        self.strongCriticism = strongCriticism
        self.easyEmotions = easyEmotions
        self.notSeekSatisfaction = notSeekSatisfaction
        self.tryingToGetSatisfaction = tryingToGetSatisfaction
        self.incompetence = incompetence
        self.loveCraving = loveCraving
        self.interestInFamily = interestInFamily
        self.grownIndependently = grownIndependently
        self.lossOfLivelihood = lossOfLivelihood
        self.realityVerification = realityVerification
        self.instability = instability
        self.immaturity = immaturity
        self.strongDesireForStability = strongDesireForStability
        self.lossOfSelfConttrol = lossOfSelfConttrol
        self.helpless = helpless
        self.face = face
        self.feelingRejected = feelingRejected
        self.stonglyConscious = stonglyConscious
        self.resistive = resistive
        self.successiveBeats = successiveBeats
        self.dependentOnOthers = dependentOnOthers
        self.calm = calm
    }
    
    func getTitle() -> [String]{
        return [
            "자신을 활력이 넘치는 존재로 생각, 강한 달성욕구, 자기 통제, 질서 정연",
            "자신이 외계의 힘에 의해 움직여지고 있다는 감정을 가짐",
            "폐쇄적, 자기주장이 약함, 우울",
            "열등감, 무력감, 우울감, 죄책감, 폐쇄적, 신경증/정신분열증",
            "부적응의 징후, 부적응감, 공허함",
            "감수성이 강함, 외부의 압력 의식하면서 자신의 통제력이 미치지 못함",
            "유년기에 따뜻함과 건전한 자극의 부재, 정신적으로 성숙하지 않음",
            "병적 징후, 통제하기 힘든 충동 존재, 자아붕괴",
            "환경에 대하여 적극적, 현실과 공상에서 공격적으로 행동",
            "무력감, 부적응",
            "융통성 없는 성격, 생동감 결여, 겉치레만 제일로 여기는 사람",
            "느리거나 착실한 사람, 둔감한 이해력",
            "과거에 대한 강한 고착",
            "외계에 대한 불신감, 비협조성",
            "환경에서의 압력과 긴장",
            "심리적 외상",
            "높은 에너지",
            "낮은 에너지, 살아가려는 의지 결여",
            "나이가 들어가면서 관심이 확장됨, 보다 활기찬 생활을 하는 사람",
            "살려는 의지를 잃은 우울하고 자살하고 싶은 충동을 가진 사람",
            "풍부한 감수성, 외계로부터 자극에 잘 반응하는 사람",
            "외향적, 충동과 본능을 완전히 밖으로 표출함, 앞뒤 생각 없이 함부로 행동하는 경향이 있음",
            "(학령기 이후 아동) 지능 및 성격 면에서 가벼운 지체 | (성인) 지능 및 성격의 퇴행",
            "자기 발전 및 행동 억제, 개방적, 흥미를 가지지만 충동을 통제하지 못함",
            "강한 비판성과 감수성, 강한 적의와 공격적 충동",
            "감정이 고양되기 쉽고 활동적, 현실무시, 사물에 열중, 억제력 부족, 현실보다 공상에 만족, 내향성",
            "환경으로부터 만족을 얻으려고 하지 않음",
            "주변환경에서 만족을 얻으려 애씀",
            "기본적인 욕구충족에 대한 무능감, 좌절",
            "(아동) 애정 갈망, 좌절된 욕구불만",
            "가족이나 안정에 대한 관심, 애착",
            "가족들에게서 떨어져 독립적으로 성장했을 수 있음",
            "자기의 생활력과 충동 상실, 현실을 다루는 일이 잘되지 않는다고 느낌",
            "현실검증력 장애",
            "불안정감, 안정에 대한 욕구",
            "미성숙, 성장 방해",
            "안정에 대한 강한 욕구, 쾌활한 성격, 예리한 관찰력",
            "외부의 압력에 자아의 통제 상실, 감수성이 강한 사람, 자기 존재 과시",
            "무력감이 있으나 표면적으로 적응해 가는 사람",
            "체면, 겉치레 중요시, 통찰력 부족, 자신 찬미",
            "(여성) 자신이 거부되고 있다는 감정, 체념, 포기, 죄의식, 거리감, 스스로를 타락했다고 믿음",
            "(아동) 권위적 인물과의 관계를 강하게 의식 | (성인) 정신발달의 미숙",
            "저항적, 부정적",
            "행동에 대한 연속적 박탈경험",
            "타인에게 의존적, 타인으로부터 인정받고 싶은 사람",
            "행동에 있어서 침착하지만 곧 불안해지며 타인으로부터 인정을 구하는 사람",
        ]
    }
    
    func getResults() -> [InspectionSeverityModel]{
        return [
            self.energeticBeing,
            self.haveFeelingsThatBeingDriven,
            self.closed,
            self.inferior,
            self.signsOfMaladjustment,
            self.strongSensitivity,
            self.lackOfWarmth,
            self.pathologicalSigns,
            self.actAggressively,
            self.helplessness,
            self.inflexiblePersonality,
            self.slow,
            self.strongFixationOnPast,
            self.disbeliefInExtraterestrials,
            self.pressure,
            self.psychologicalTrauma,
            self.highEnergy,
            self.lowEnergy,
            self.interestExpands,
            self.depressed,
            self.richSensitivity,
            self.extroversion,
            self.intellignece,
            self.selfImprovement,
            self.strongCriticism,
            self.easyEmotions,
            self.notSeekSatisfaction,
            self.tryingToGetSatisfaction,
            self.incompetence,
            self.loveCraving,
            self.interestInFamily,
            self.grownIndependently,
            self.lossOfLivelihood,
            self.realityVerification,
            self.instability,
            self.immaturity,
            self.strongDesireForStability,
            self.lossOfSelfConttrol,
            self.helpless,
            self.face,
            self.feelingRejected,
            self.stonglyConscious,
            self.resistive,
            self.successiveBeats,
            self.dependentOnOthers,
            self.calm
        ]
    }
}
