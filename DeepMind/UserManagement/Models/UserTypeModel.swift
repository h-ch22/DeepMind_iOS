//
//  UserTypeModel.swift
//  DeepMind
//
//  Created by 하창진 on 8/30/23.
//

import Foundation

enum UserTypeModel: CaseIterable, CustomStringConvertible{
    case CUSTOMER, PROFESSIONAL
    
    var description: String{
        switch self{
        case .CUSTOMER: return "사용자"
        case .PROFESSIONAL: return "전문가"
        }
    }
    
    var code: String{
        switch self{
        case .CUSTOMER: return "Customer"
        case .PROFESSIONAL: return "Professional"
        }
    }
}
