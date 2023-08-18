//
//  PersonGenderModel.swift
//  DeepMind
//
//  Created by 하창진 on 8/1/23.
//

import Foundation

enum PersonGenderModel: Identifiable, CaseIterable, CustomStringConvertible{
    var id: Self {self}
    case MALE, FEMALE, NONE
    
    var description: String{
        switch self{
        case .MALE:
            return "남자"
            
        case .FEMALE:
            return "여자"
            
        case .NONE:
            return "중립/알 수 없음"
        }
    }
    
    static func getType(description: String) -> Self{
        switch description{
        case "남자":
            return .MALE
            
        case "여자":
            return .FEMALE
            
        case "중립/알 수 없음":
            return .NONE
            
        default:
            return .MALE
        }
    }
}
