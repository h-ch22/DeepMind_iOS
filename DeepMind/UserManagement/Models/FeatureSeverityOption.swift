//
//  FeatureSeverityOption.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation

enum FeatureSeverityOption: CaseIterable, CustomStringConvertible{
    case TRUE, FALSE
    
    var description: String{
        switch self{
        case .TRUE:
            return "예"
            
        case .FALSE:
            return "아니오"
        }
    }
    
    var code: Int{
        switch self{
        case .TRUE:
            return 1
            
        case .FALSE:
            return 0
        }
    }
}
