//
//  DrawingTypeModel.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import Foundation

enum DrawingTypeModel: CaseIterable, CustomStringConvertible{
    case HOUSE, TREE, PERSON
    
    var description: String{
        switch self{
        case .HOUSE:
            return "집"
            
        case .TREE:
            return "나무"
            
        case .PERSON:
            return "사람"
        }
    }
    
    var code: Int{
        switch self{
        case .HOUSE:
            return 1
            
        case .TREE:
            return 2
            
        case .PERSON:
            return 3
        }
    }
}
