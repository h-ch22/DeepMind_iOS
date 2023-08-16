//
//  DiaryEmotionModel.swift
//  DeepMind
//
//  Created by 하창진 on 8/7/23.
//

import Foundation

enum DiaryEmotionModel{
    case HAPPY, GREAT, GOOD, SOSO, BAD, SAD, STAY_ALONE, ANGRY
    
    var description: String{
        switch self{
        case .HAPPY:
            return "HAPPY"
            
        case .GREAT:
            return "GREAT"
            
        case .GOOD:
            return "GOOD"
            
        case .SOSO:
            return "SOSO"
            
        case .BAD:
            return "BAD"
            
        case .SAD:
            return "SAD"
            
        case .STAY_ALONE:
            return "STAY_ALONE"
            
        case .ANGRY:
            return "ANGRY"
        }
    }
    
    var code: Int{
        switch self{
        case .HAPPY:
            return 0
            
        case .GREAT:
            return 1
            
        case .GOOD:
            return 2
            
        case .SOSO:
            return 3
            
        case .BAD:
            return 4
            
        case .SAD:
            return 5
            
        case .STAY_ALONE:
            return 6
            
        case .ANGRY:
            return 7
        }
    }
}
