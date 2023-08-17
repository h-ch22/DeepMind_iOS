//
//  InspectionEssentialQuestionType.swift
//  DeepMind
//
//  Created by 하창진 on 8/16/23.
//

import Foundation

struct InspectionEssentialQuestionType{
    var question: String
    var isYesNoQuestion: Bool
    
    init(question: String, isYesNoQuestion: Bool) {
        self.question = question
        self.isYesNoQuestion = isYesNoQuestion
    }
}
