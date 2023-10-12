//
//  InspectionResultModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import Foundation

struct InspectionResultModel{
    var emotionalDisorder: InspectionSeverityModel
    var inferiority: InspectionSeverityModel
    var severeDepression: InspectionSeverityModel
    var manic: InspectionSeverityModel
    var selfFirst: InspectionSeverityModel
    var lackOfPlanning: InspectionSeverityModel
    var alcoholics: InspectionSeverityModel
    var hysetical: InspectionSeverityModel
    var normalAndStable: InspectionSeverityModel
    var fantasticism: InspectionSeverityModel
    var introverted: InspectionSeverityModel
    var pastStickiness: InspectionSeverityModel
    var extroverted: InspectionSeverityModel
    var stability: InspectionSeverityModel
    var impulsiveness: InspectionSeverityModel
    var conscious: InspectionSeverityModel
    var environmentalPhysicalBarriers: InspectionSeverityModel
    var poorExerciseControl: InspectionSeverityModel
    var brainDamage: InspectionSeverityModel
    var patientAndStable: InspectionSeverityModel
    var fast: InspectionSeverityModel
    var adaptToTheOutside: InspectionSeverityModel
    var slow: InspectionSeverityModel
    var stickingToSpecificPart: InspectionSeverityModel
    var neurology: InspectionSeverityModel
    var obsessive: InspectionSeverityModel
    var insecurity: InspectionSeverityModel
    var uncompromising: InspectionSeverityModel
    var escapist: InspectionSeverityModel
    var simplicity: InspectionSeverityModel
    var exposure: InspectionSeverityModel
    var lowMentalIntelligence: InspectionSeverityModel
    var selfClosed: InspectionSeverityModel
    var guiltyConscience: InspectionSeverityModel
    var delusionalSchizophrenia: InspectionSeverityModel
    var anxiety: InspectionSeverityModel
    var morbidOmen: InspectionSeverityModel
    var difficultyAccessToEnvironment: InspectionSeverityModel
    var bystanderAttitude: InspectionSeverityModel
    var workToWardToFuture: InspectionSeverityModel
    var futureuncertainty: InspectionSeverityModel
    var specialFeelingsForParents: InspectionSeverityModel
    
    init(emotionalDisorder: InspectionSeverityModel, inferiority: InspectionSeverityModel, severeDepression: InspectionSeverityModel, manic: InspectionSeverityModel, selfFirst: InspectionSeverityModel, lackOfPlanning: InspectionSeverityModel, alcoholics: InspectionSeverityModel, hysetical: InspectionSeverityModel, normalAndStable: InspectionSeverityModel, fantasticism: InspectionSeverityModel, introverted: InspectionSeverityModel, pastStickiness: InspectionSeverityModel, extroverted: InspectionSeverityModel, stability: InspectionSeverityModel, impulsiveness: InspectionSeverityModel, conscious: InspectionSeverityModel, environmentalPhysicalBarriers: InspectionSeverityModel, poorExerciseControl: InspectionSeverityModel, brainDamage: InspectionSeverityModel, patientAndStable: InspectionSeverityModel, fast: InspectionSeverityModel, adaptToTheOutside: InspectionSeverityModel, slow: InspectionSeverityModel, stickingToSpecificPart: InspectionSeverityModel, neurology: InspectionSeverityModel, obsessive: InspectionSeverityModel, insecurity: InspectionSeverityModel, uncompromising: InspectionSeverityModel, escapist: InspectionSeverityModel, simplicity: InspectionSeverityModel, exposure: InspectionSeverityModel, lowMentalIntelligence: InspectionSeverityModel, selfClosed: InspectionSeverityModel, guiltyConscience: InspectionSeverityModel, delusionalSchizophrenia: InspectionSeverityModel, anxiety: InspectionSeverityModel, morbidOmen: InspectionSeverityModel, difficultyAccessToEnvironment: InspectionSeverityModel, bystanderAttitude: InspectionSeverityModel, workToWardToFuture: InspectionSeverityModel, futureuncertainty: InspectionSeverityModel, specialFeelingsForParents: InspectionSeverityModel) {
        self.emotionalDisorder = emotionalDisorder
        self.inferiority = inferiority
        self.severeDepression = severeDepression
        self.manic = manic
        self.selfFirst = selfFirst
        self.lackOfPlanning = lackOfPlanning
        self.alcoholics = alcoholics
        self.hysetical = hysetical
        self.normalAndStable = normalAndStable
        self.fantasticism = fantasticism
        self.introverted = introverted
        self.pastStickiness = pastStickiness
        self.extroverted = extroverted
        self.stability = stability
        self.impulsiveness = impulsiveness
        self.conscious = conscious
        self.environmentalPhysicalBarriers = environmentalPhysicalBarriers
        self.poorExerciseControl = poorExerciseControl
        self.brainDamage = brainDamage
        self.patientAndStable = patientAndStable
        self.fast = fast
        self.adaptToTheOutside = adaptToTheOutside
        self.slow = slow
        self.stickingToSpecificPart = stickingToSpecificPart
        self.neurology = neurology
        self.obsessive = obsessive
        self.insecurity = insecurity
        self.uncompromising = uncompromising
        self.escapist = escapist
        self.simplicity = simplicity
        self.exposure = exposure
        self.lowMentalIntelligence = lowMentalIntelligence
        self.selfClosed = selfClosed
        self.guiltyConscience = guiltyConscience
        self.delusionalSchizophrenia = delusionalSchizophrenia
        self.anxiety = anxiety
        self.morbidOmen = morbidOmen
        self.difficultyAccessToEnvironment = difficultyAccessToEnvironment
        self.bystanderAttitude = bystanderAttitude
        self.workToWardToFuture = workToWardToFuture
        self.futureuncertainty = futureuncertainty
        self.specialFeelingsForParents = specialFeelingsForParents
    }
    
    func getTitle() -> [String]{
        return [
            "정서장애",
            "열등감, 무능력함, 억제, 소심, 낮은 에너지, 이치에 맞지 않는 낙천주의",
            "수축된 자아, 심한 우울증",
            "기질적 장애, 아동정신적 장애, 조증",
            "자기 우선 주의",
            "계획능력 부족, 조증, 과잉 행동",
            "억압성, 알콜중독",
            "히스테리성 정신질환",
            "정상적, 안정적, 인간관계에 대한 완고함",
            "공상주의",
            "내향적, 자의식 과잉, 공상적, 여성적",
            "과거 고착성, 충동성, 의존성",
            "외향적, 남성적, 미래성",
            "우울, 패배, 위축, 무의식, 안정",
            "강한 충동성",
            "의식, 초월, 불안정, 낙천적",
            "환경에 대한 물리적 장벽",
            "빈약한 운동 통제",
            "두뇌 손상",
            "인내심, 안정적",
            "빠름, 단호함, 주장적",
            "외부에 적응하는데 있어 유연한 태도",
            "느림, 우유부단함, 의존적, 감정적, 유순함",
            "특정 부분에 대한 고착",
            "신경증, 갈등, 특별한 곤란과 불안",
            "강박증적 경향",
            "불안정함, 부적응감",
            "경직성, 타협 불가 성질",
            "도피적, 자폐적",
            "소박함, 신중, 복잡",
            "(여성) 허영심, 노출증 (남성) 노출증, 과시",
            "낮은 수준의 정신 지능, 정신분열",
            "자기 폐쇄적 사고",
            "사회접촉에 죄의식, 신체 노출 경향",
            "망상형 정신분열",
            "불안, 지지 필요",
            "병적인 징조, 정신분열",
            "환경에 대한 접근 어려움",
            "방관자적 태도",
            "미래를 향해 노력하는 사람",
            "미래가 불확실한 사람",
            "부모에 대한 특별한 감정"
        ]
    }
    
    func getResults() -> [InspectionSeverityModel]{
        return [
            self.emotionalDisorder,
            self.inferiority,
            self.severeDepression,
            self.manic,
            self.selfFirst,
            self.lackOfPlanning,
            self.alcoholics,
            self.hysetical,
            self.normalAndStable,
            self.fantasticism,
            self.introverted,
            self.pastStickiness,
            self.extroverted,
            self.stability,
            self.impulsiveness,
            self.conscious,
            self.environmentalPhysicalBarriers,
            self.poorExerciseControl,
            self.brainDamage,
            self.patientAndStable,
            self.fast,
            self.adaptToTheOutside,
            self.slow,
            self.stickingToSpecificPart,
            self.neurology,
            self.obsessive,
            self.insecurity,
            self.uncompromising,
            self.escapist,
            self.simplicity,
            self.exposure,
            self.lowMentalIntelligence,
            self.selfClosed,
            self.guiltyConscience,
            self.delusionalSchizophrenia,
            self.anxiety,
            self.morbidOmen,
            self.difficultyAccessToEnvironment,
            self.bystanderAttitude,
            self.workToWardToFuture,
            self.futureuncertainty,
            self.specialFeelingsForParents
        ]
    }
}
