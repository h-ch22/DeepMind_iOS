//
//  StatisticsEmotionDataModel.swift
//  DeepMind
//
//  Created by 하창진 on 8/16/23.
//

import Foundation

struct StatisticsEmotionDataModel: Identifiable{
    var emotion: String
    var count: Int
    
    var id: String{emotion}
}
