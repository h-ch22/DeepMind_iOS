//
//  HouseSeverityModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import Foundation

struct HouseResultModel{
    var scienceFiction: InspectionSeverityModel
    var emotionalAwareness: InspectionSeverityModel
    var obsessed: InspectionSeverityModel
    var lackOfControl: InspectionSeverityModel
    var selfDefense: InspectionSeverityModel
    var healthySelf: InspectionSeverityModel
    var poorSelfControl: InspectionSeverityModel
    var criticalPower: InspectionSeverityModel
    var insufficientContact: InspectionSeverityModel
    var anxietyAtRealLevel: InspectionSeverityModel
    var reluctantToEnvironment: InspectionSeverityModel
    var excessiveDependence: InspectionSeverityModel
    var desireToEmotionalWarmth: InspectionSeverityModel
    var emotionsOfNotWantingToContact: InspectionSeverityModel
    var paranoia: InspectionSeverityModel
    var defensive: InspectionSeverityModel
    var preferenceOfDualRoles: InspectionSeverityModel
    var openness: InspectionSeverityModel
    var skepticism: InspectionSeverityModel
    var characteristicsOfTheLipid: InspectionSeverityModel
    var sticking: InspectionSeverityModel
    var femeinine: InspectionSeverityModel
    var existenceOfTension: InspectionSeverityModel
    var lackOfHomeWarmth: InspectionSeverityModel
    var pessimisticThoughtsFuture: InspectionSeverityModel
    var distancingSelf: InspectionSeverityModel
    var defensiveMeasures: InspectionSeverityModel
    var levelOfAnxiety: InspectionSeverityModel
    var strongDesireForDependence: InspectionSeverityModel
    var obviousEnvySim: InspectionSeverityModel
    var seekingMotherProtection: InspectionSeverityModel
    
    init(scienceFiction: InspectionSeverityModel, emotionalAwareness: InspectionSeverityModel, obsessed: InspectionSeverityModel, lackOfControl: InspectionSeverityModel, selfDefense: InspectionSeverityModel, healthySelf: InspectionSeverityModel, poorSelfControl: InspectionSeverityModel, criticalPower: InspectionSeverityModel, insufficientContact: InspectionSeverityModel, anxietyAtRealLevel: InspectionSeverityModel, reluctantToEnvironment: InspectionSeverityModel, excessiveDependence: InspectionSeverityModel, desireToEmotionalWarmth: InspectionSeverityModel, emotionsOfNotWantingToContact: InspectionSeverityModel, paranoia: InspectionSeverityModel, defensive: InspectionSeverityModel, preferenceOfDualRoles: InspectionSeverityModel, openness: InspectionSeverityModel, skepticism: InspectionSeverityModel, characteristicsOfTheLipid: InspectionSeverityModel, sticking: InspectionSeverityModel, femeinine: InspectionSeverityModel, existenceOfTension: InspectionSeverityModel, lackOfHomeWarmth: InspectionSeverityModel, pessimisticThoughtsFuture: InspectionSeverityModel, distancingSelf: InspectionSeverityModel, defensiveMeasures: InspectionSeverityModel, levelOfAnxiety: InspectionSeverityModel, strongDesireForDependence: InspectionSeverityModel, obviousEnvySim: InspectionSeverityModel, seekingMotherProtection: InspectionSeverityModel) {
        self.scienceFiction = scienceFiction
        self.emotionalAwareness = emotionalAwareness
        self.obsessed = obsessed
        self.lackOfControl = lackOfControl
        self.selfDefense = selfDefense
        self.healthySelf = healthySelf
        self.poorSelfControl = poorSelfControl
        self.criticalPower = criticalPower
        self.insufficientContact = insufficientContact
        self.anxietyAtRealLevel = anxietyAtRealLevel
        self.reluctantToEnvironment = reluctantToEnvironment
        self.excessiveDependence = excessiveDependence
        self.desireToEmotionalWarmth = desireToEmotionalWarmth
        self.emotionsOfNotWantingToContact = emotionsOfNotWantingToContact
        self.paranoia = paranoia
        self.defensive = defensive
        self.preferenceOfDualRoles = preferenceOfDualRoles
        self.openness = openness
        self.skepticism = skepticism
        self.characteristicsOfTheLipid = characteristicsOfTheLipid
        self.sticking = sticking
        self.femeinine = femeinine
        self.existenceOfTension = existenceOfTension
        self.lackOfHomeWarmth = lackOfHomeWarmth
        self.pessimisticThoughtsFuture = pessimisticThoughtsFuture
        self.distancingSelf = distancingSelf
        self.defensiveMeasures = defensiveMeasures
        self.levelOfAnxiety = levelOfAnxiety
        self.strongDesireForDependence = strongDesireForDependence
        self.obviousEnvySim = obviousEnvySim
        self.seekingMotherProtection = seekingMotherProtection
    }
    
    func getTitle() -> [String]{
        return [
            "공상 주의, 대인관계 도피",
            "자신이 압도되었다는 감정 인식",
            "집착적",
            "공상 통제 능력 결여",
            "자기 방어 기질",
            "건강한 자아",
            "자아 통제 부실",
            "비판력, 현실검증 부적당",
            "현실과 접촉 불충분",
            "현실수준에서의 불안",
            "환경과의 접촉 꺼림, 우유부단함에 지배됨",
            "타인에 대한 과도한 의존심",
            "외부로부터 정서적인 따뜻함을 얻고 싶어하는 갈망",
            "가정환경에서 타인과 접촉하지 않으려는 감정, 외부세계와의 교류를 원치 않음",
            "편집증적인 예민성",
            "방어적, 의심 과다",
            "가정에서 이중의 역할 선호",
            "개방, 환경적 접촉에 대한 갈망",
            "회의감, 외부로부터 자기를 멀리함",
            "구순적 성격의 특징",
            "여성생식기에 대한 고착 또는 지나친 관심",
            "여성적, 신사적, 부드러운 사람",
            "긴장 존재 또는 가정환경 내 갈등 및 정서 혼란 존재",
            "가정의 따뜻함 결여 또는 에로티시즘의 정신-성적발달 단계",
            "미래에 대한 염세적인 생각",
            "타인과의 상호작용에 거리를 둠, 친구를 사귈 때 시간이 걸리고 경계, 친숙해지면 매우 친해짐",
            "방어 수단, 안전을 방해받고 싶지 않음",
            "어느 정도 불안이 있으나 통제능력이 있음",
            "의존에 대한 강한 욕구, 부모에게 지배당하고 있는 감정이 있음",
            "명백한 시기심, 경계심, 가정으로부터 거부됨",
            "어머니의 보호를 구하며 안전의 욕구를 지님"
        ]
    }
    
    func getResults() -> [InspectionSeverityModel]{
        return [
            self.scienceFiction,
            self.emotionalAwareness,
            self.obsessed,
            self.lackOfControl,
            self.selfDefense,
            self.healthySelf,
            self.poorSelfControl,
            self.criticalPower,
            self.insufficientContact,
            self.anxietyAtRealLevel,
            self.reluctantToEnvironment,
            self.excessiveDependence,
            self.desireToEmotionalWarmth,
            self.emotionsOfNotWantingToContact,
            self.paranoia,
            self.defensive,
            self.preferenceOfDualRoles,
            self.openness,
            self.skepticism,
            self.characteristicsOfTheLipid,
            self.sticking,
            self.femeinine,
            self.existenceOfTension,
            self.lackOfHomeWarmth,
            self.pessimisticThoughtsFuture,
            self.distancingSelf,
            self.defensiveMeasures,
            self.levelOfAnxiety,
            self.strongDesireForDependence,
            self.obviousEnvySim,
            self.seekingMotherProtection
        ]
    }
}
