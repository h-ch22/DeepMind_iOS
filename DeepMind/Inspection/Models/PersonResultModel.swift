//
//  PersonResultModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import Foundation

struct PersonResultModel{
    var thinkingDisorder: InspectionSeverityModel
    var lowConfidence: InspectionSeverityModel
    var strongIntellectualEffort: InspectionSeverityModel
    var obsessivePatients: InspectionSeverityModel
    var avoidFacingWorld: InspectionSeverityModel
    var lackOfConfidence: InspectionSeverityModel
    var compensationPsychology: InspectionSeverityModel
    var extremeAnxietyInEmotionalExchange: InspectionSeverityModel
    var ambivalenceOfApproach: InspectionSeverityModel
    var expressionOfEmotions: InspectionSeverityModel
    var atrophy: InspectionSeverityModel
    var anxietyInEmotionalExchange: InspectionSeverityModel
    var innerEmptiness: InspectionSeverityModel
    var narrowingTheChannel: InspectionSeverityModel
    var irritable: InspectionSeverityModel
    var obsessivePersonality: InspectionSeverityModel
    var contempt: InspectionSeverityModel
    var wild: InspectionSeverityModel
    var sentimentsAnxiety: InspectionSeverityModel
    var extremeSensitivity: InspectionSeverityModel
    var emotionalStimulus: InspectionSeverityModel
    var anxietyAboutEmotionalExchange: InspectionSeverityModel
    var veryInterestedInAppearance: InspectionSeverityModel
    var desireToShowOffOneSelf: InspectionSeverityModel
    var conflictWithSex: InspectionSeverityModel
    var homosexualTendencies: InspectionSeverityModel
    var powerStruggles: InspectionSeverityModel
    var agression: InspectionSeverityModel
    var considerableAggression: InspectionSeverityModel
    var bad: InspectionSeverityModel
    var immatureAttitude: InspectionSeverityModel
    var denialOfEarlyDepression: InspectionSeverityModel
    var projectingWeakness: InspectionSeverityModel
    var strongRejection: InspectionSeverityModel
    var conflictOrLackOfRelationships: InspectionSeverityModel
    var psychology: InspectionSeverityModel
    var avoidEmotionalInteraction: InspectionSeverityModel
    var insensitive: InspectionSeverityModel
    var personalityHostility: InspectionSeverityModel
    var excessiveDesireForAffection: InspectionSeverityModel
    var interpersonalInteractions: InspectionSeverityModel
    var happiness: InspectionSeverityModel
    var needAuthority: InspectionSeverityModel
    var weakness: InspectionSeverityModel
    var symbolOfPower: InspectionSeverityModel
    var desireToSignify: InspectionSeverityModel
    var sexualImmorality: InspectionSeverityModel
    var activeDaydreaming: InspectionSeverityModel
    var personallyExcessive: InspectionSeverityModel
    var excessivePassive: InspectionSeverityModel
    var impulsiveness: InspectionSeverityModel
    var selfish: InspectionSeverityModel
    
    init(thinkingDisorder: InspectionSeverityModel, lowConfidence: InspectionSeverityModel, strongIntellectualEffort: InspectionSeverityModel, obsessivePatients: InspectionSeverityModel, avoidFacingWorld: InspectionSeverityModel, lackOfConfidence: InspectionSeverityModel, compensationPsychology: InspectionSeverityModel, extremeAnxietyInEmotionalExchange: InspectionSeverityModel, ambivalenceOfApproach: InspectionSeverityModel, expressionOfEmotions: InspectionSeverityModel, atrophy: InspectionSeverityModel, anxietyInEmotionalExchange: InspectionSeverityModel, innerEmptiness: InspectionSeverityModel, narrowingTheChannel: InspectionSeverityModel, irritable: InspectionSeverityModel, obsessivePersonality: InspectionSeverityModel, contempt: InspectionSeverityModel, wild: InspectionSeverityModel, sentimentsAnxiety: InspectionSeverityModel, extremeSensitivity: InspectionSeverityModel, emotionalStimulus: InspectionSeverityModel, anxietyAboutEmotionalExchange: InspectionSeverityModel, veryInterestedInAppearance: InspectionSeverityModel, desireToShowOffOneSelf: InspectionSeverityModel, conflictWithSex: InspectionSeverityModel, homosexualTendencies: InspectionSeverityModel, powerStruggles: InspectionSeverityModel, agression: InspectionSeverityModel, considerableAggression: InspectionSeverityModel, bad: InspectionSeverityModel, immatureAttitude: InspectionSeverityModel, denialOfEarlyDepression: InspectionSeverityModel, projectingWeakness: InspectionSeverityModel, strongRejection: InspectionSeverityModel, conflictOrLackOfRelationships: InspectionSeverityModel, psychology: InspectionSeverityModel, avoidEmotionalInteraction: InspectionSeverityModel, insensitive: InspectionSeverityModel, personalityHostility: InspectionSeverityModel, excessiveDesireForAffection: InspectionSeverityModel, interpersonalInteractions: InspectionSeverityModel, happiness: InspectionSeverityModel, needAuthority: InspectionSeverityModel, weakness: InspectionSeverityModel, symbolOfPower: InspectionSeverityModel, desireToSignify: InspectionSeverityModel, sexualImmorality: InspectionSeverityModel, activeDaydreaming: InspectionSeverityModel, personallyExcessive: InspectionSeverityModel, excessivePassive: InspectionSeverityModel, impulsiveness: InspectionSeverityModel, selfish: InspectionSeverityModel) {
        self.thinkingDisorder = thinkingDisorder
        self.lowConfidence = lowConfidence
        self.strongIntellectualEffort = strongIntellectualEffort
        self.obsessivePatients = obsessivePatients
        self.avoidFacingWorld = avoidFacingWorld
        self.lackOfConfidence = lackOfConfidence
        self.compensationPsychology = compensationPsychology
        self.extremeAnxietyInEmotionalExchange = extremeAnxietyInEmotionalExchange
        self.ambivalenceOfApproach = ambivalenceOfApproach
        self.expressionOfEmotions = expressionOfEmotions
        self.atrophy = atrophy
        self.anxietyInEmotionalExchange = anxietyInEmotionalExchange
        self.innerEmptiness = innerEmptiness
        self.narrowingTheChannel = narrowingTheChannel
        self.irritable = irritable
        self.obsessivePersonality = obsessivePersonality
        self.contempt = contempt
        self.wild = wild
        self.sentimentsAnxiety = sentimentsAnxiety
        self.extremeSensitivity = extremeSensitivity
        self.emotionalStimulus = emotionalStimulus
        self.anxietyAboutEmotionalExchange = anxietyAboutEmotionalExchange
        self.veryInterestedInAppearance = veryInterestedInAppearance
        self.desireToShowOffOneSelf = desireToShowOffOneSelf
        self.conflictWithSex = conflictWithSex
        self.homosexualTendencies = homosexualTendencies
        self.powerStruggles = powerStruggles
        self.agression = agression
        self.considerableAggression = considerableAggression
        self.bad = bad
        self.immatureAttitude = immatureAttitude
        self.denialOfEarlyDepression = denialOfEarlyDepression
        self.projectingWeakness = projectingWeakness
        self.strongRejection = strongRejection
        self.conflictOrLackOfRelationships = conflictOrLackOfRelationships
        self.psychology = psychology
        self.avoidEmotionalInteraction = avoidEmotionalInteraction
        self.insensitive = insensitive
        self.personalityHostility = personalityHostility
        self.excessiveDesireForAffection = excessiveDesireForAffection
        self.interpersonalInteractions = interpersonalInteractions
        self.happiness = happiness
        self.needAuthority = needAuthority
        self.weakness = weakness
        self.symbolOfPower = symbolOfPower
        self.desireToSignify = desireToSignify
        self.sexualImmorality = sexualImmorality
        self.activeDaydreaming = activeDaydreaming
        self.personallyExcessive = personallyExcessive
        self.excessivePassive = excessivePassive
        self.impulsiveness = impulsiveness
        self.selfish = selfish
    }
    
    func getTitle() -> [String]{
        return [
            "사고장애, 신경학적 장애",
            "지적능력에 대한 낮은 자신감, 불안감",
            "강한 지적노력, 지적 성취에 대한 압박, 공격성, 자기 중심적 태도, 편집증",
            "강박증 환자, 지적 부족감",
            "세상과 직면을 피함, 외모에 대한 극도의 불안감, 세상에 대해 억제적이고 회피적, 억압된 분노감, 거부적 태도",
            "자신감 부족, 직접적인 사회적 접촉 꺼림",
            "쾌락, 힘, 남성적 면이 부족하다는 생각에 대한 보상심리",
            "타인과 감정 교류에 극심한 불안감, 사고장애의 가능성이 있음",
            "감정교류에 있어 접근과 회피의 양가감정",
            "사회적 불안으로 감정 표현, 타인 감정 수용에 매우 위축, 다른 사람에 대한 적대심",
            "타인과 정서적 교류에 있어 지나치게 예민함",
            "사회적 상호작용에서 위축, 회피되고자 함, 자아도취",
            "감정적 교류에 있어 불안감, 김장감, 타인과 상호작용에서 의심, 방어적 태도, 편집증적인 경향성",
            "내적인 공허감, 타인의 감정을 알고 싶지 않고, 자신의 감정을 보이고 싶지 않음",
            "감정 교류 소통의 채널을 좁힘, 타인과 감정 교류나 감정 표현에 있어 한계를 느낌",
            "타인과 정서적인 교류에 과민, 집착",
            "강박적 성격, 히스테리적 성격, 자기애적 성격",
            "세련됨, 몸치장을 잘함",
            "경멸, 건방진 태도",
            "야성적, 거침, 억제되지 않음",
            "정서적 교류나 감정표현에 대한 불안감",
            "대인관계에 대한 극도의 예민함",
            "정서적 자극 회피, 위축됨",
            "감정 교류에 대한 불안감, 긴장감, 다른 사람이 나를 어떻게 생각하는가에 대한 예민함, 타인의 의도에 대한 불신, 의심",
            "외모에 관심이 많음",
            "타인에게 자신을 과시함, 자기애적 욕구, 대인관계 불안감을 강박적으로 보상하고자 하는 욕구",
            "성에 대한 갈등, 남성적인 것을 거부, 거세에 대한 불안감, 동성애적 경향, 타인에게 어떻게 보일지에 대한 극도의 예민감, 두려움",
            "권력 투쟁, 유아기적 성",
            "공격성, 우월을 탐함, 외향적, 활동적",
            "상당한 공격성, 우월성 추구",
            "나쁘고 탐욕스러운 사고",
            "대인관계 상호작용에 대한 미성숙한 태도, 공격적인 행동",
            "우울증 초기 환자의 경향 또는 남성역할을 하는 것에 대한 부정",
            "여성에 대한 약점을 투사, 유아적인 남성에 있어 거세의 감정",
            "애정 욕구의 강한 거부, 심한 죄의식, 우울, 부모와 같은 대상과의 관계에 상당한 갈등 또는 결핍",
            "타인과 정서적 교류, 애정의 교류에 있어 불안감을 느끼지만 과도하게 적극적이고 주장적이며, 공격적인 태도를 취함으로 역공포적으로 불안감을 보상받으려는 심리",
            "내적 상처를 받지 않기 위해 정서적 상호작용 회피, 타인의 애정어린 태도 거절, 이와 관련해 절망감, 우울감을 느낌",
            "타인과 정서적 교류에서 무감각, 냉정한 태도",
            "성격적으로 적대감, 공격성 내재",
            "타인의 애정을 지나치게 원함, 친밀한 관계에 지나친 몰두",
            "대인관계 상호작용에서 무기력감, 수동적 태도",
            "(5세 이하): 행복감, 기쁨 | (6세 이상): 정서적 욕구충족, 애정욕구 충족에 있어 심각한 좌절, 상처받을까 하는 불안감",
            "권위, 우월을 필요로 함",
            "사회적 지위에서의 약함",
            "자신의 목표를 향해 일하려는 힘의 상징",
            "특이한 방법으로 사내다움을 나타내려는 남자다움에 대한 상징적 표시의 욕구, 예술가, 반사회적",
            "성적 부도덕, 통제의 결여",
            "활발한 공상",
            "성격적으로 지나친 자신감, 적극적, 자기주장적, 공격적, 자기애적, 히스테리적",
            "성적인 면에서 지나치게 수동적, 억제적",
            "(청소년) 성욕에 대한 충동성, 알콜중독자, 편집증 여성의 망상",
            "자기애적, 자기중심적, 강한 자만심"
        ]
    }
    
    func getResults() -> [InspectionSeverityModel]{
        return [
            self.thinkingDisorder,
            self.lowConfidence,
            self.strongIntellectualEffort,
            self.obsessivePatients,
            self.avoidFacingWorld,
            self.lackOfConfidence,
            self.compensationPsychology,
            self.extremeAnxietyInEmotionalExchange,
            self.ambivalenceOfApproach,
            self.expressionOfEmotions,
            self.atrophy,
            self.anxietyInEmotionalExchange,
            self.innerEmptiness,
            self.narrowingTheChannel,
            self.irritable,
            self.obsessivePersonality,
            self.contempt,
            self.wild,
            self.sentimentsAnxiety,
            self.extremeSensitivity,
            self.emotionalStimulus,
            self.anxietyAboutEmotionalExchange,
            self.veryInterestedInAppearance,
            self.desireToShowOffOneSelf,
            self.conflictWithSex,
            self.homosexualTendencies,
            self.powerStruggles,
            self.agression,
            self.considerableAggression,
            self.bad,
            self.immatureAttitude,
            self.denialOfEarlyDepression,
            self.projectingWeakness,
            self.strongRejection,
            self.conflictOrLackOfRelationships,
            self.psychology,
            self.avoidEmotionalInteraction,
            self.insensitive,
            self.personalityHostility,
            self.excessiveDesireForAffection,
            self.interpersonalInteractions,
            self.happiness,
            self.needAuthority,
            self.weakness,
            self.symbolOfPower,
            self.desireToSignify,
            self.sexualImmorality,
            self.activeDaydreaming,
            self.personallyExcessive,
            self.excessivePassive,
            self.impulsiveness,
            self.selfish
        ]
    }
}
