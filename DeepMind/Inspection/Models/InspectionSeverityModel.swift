//
//  InspectionSeverityModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import Foundation

enum InspectionSeverityModel: String{
    case HIGHLY_LIKELY = "매우 높음"
    case MODERATELY_LIKELY = "다소 높음"
    case LIKELY = "높음"
    case EVEN_ODDS = "보통"
    case NOT_VERY_LIKELY = "다소 낮음"
    case IMPROBABLE = "낮음"
    case HIGHLY_IMPROBABLE = "매우 낮음"
    
    var level: Int{
        switch self{
        case .HIGHLY_LIKELY:
            return 7
            
        case .MODERATELY_LIKELY:
            return 6
            
        case .LIKELY:
            return 5
            
        case .EVEN_ODDS:
            return 4
            
        case .NOT_VERY_LIKELY:
            return 3
            
        case .IMPROBABLE:
            return 2
            
        case .HIGHLY_IMPROBABLE:
            return 1
        }
    }
}
