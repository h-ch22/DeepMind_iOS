//
//  InspectionHistoryModel.swift
//  DeepMind
//
//  Created by 하창진 on 8/18/23.
//

import Foundation

struct InspectionHistoryModel{
    let id: String
    let img_C01: URL?
    let img_detected_C01: URL?
    let answer_C01: HouseEssentialQuestionAnswerModel
    let img_C02: URL?
    let img_detected_C02: URL?
    let answer_C02: TreeEssentialQuestionAnswerModel
    let img_C03_1: URL?
    let img_detected_C03_1: URL?
    let answer_C03_1: PersonEssentialQuestionAnswerModel
    let img_C03_2: URL?
    let img_detected_C03_2: URL?
    let answer_C03_2: PersonEssentialQuestionAnswerModel
    
    init(id: String, img_C01: URL?, img_detected_C01: URL?, answer_C01: HouseEssentialQuestionAnswerModel, img_C02: URL?, img_detected_C02: URL?, answer_C02: TreeEssentialQuestionAnswerModel, img_C03_1: URL?, img_detected_C03_1: URL?, answer_C03_1: PersonEssentialQuestionAnswerModel, img_C03_2: URL?, img_detected_C03_2: URL?, answer_C03_2: PersonEssentialQuestionAnswerModel) {
        self.id = id
        self.img_C01 = img_C01
        self.img_detected_C01 = img_detected_C01
        self.answer_C01 = answer_C01
        self.img_C02 = img_C02
        self.img_detected_C02 = img_detected_C02
        self.answer_C02 = answer_C02
        self.img_C03_1 = img_C03_1
        self.img_detected_C03_1 = img_detected_C03_1
        self.answer_C03_1 = answer_C03_1
        self.img_C03_2 = img_C03_2
        self.img_detected_C03_2 = img_detected_C03_2
        self.answer_C03_2 = answer_C03_2
    }
}
