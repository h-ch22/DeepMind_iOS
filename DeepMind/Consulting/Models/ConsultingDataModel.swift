//
//  ConsultingDataModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation

struct ConsultingDataModel: Hashable{
    var id: String
    var message: String
    var date: String
    var time: String
    var mentorUID: String
    var imageIndex: Int
    var type: ConsultingMethodType
    var mentorName: String
    var mentorProfile: URL?
    var menteeUID: String
    var menteeName: String
    
    init(id: String, message: String, date: String, time: String, mentorUID: String, imageIndex: Int, type: ConsultingMethodType, mentorName: String, mentorProfile: URL?, menteeUID: String, menteeName: String) {
        self.id = id
        self.message = message
        self.date = date
        self.time = time
        self.mentorUID = mentorUID
        self.imageIndex = imageIndex
        self.type = type
        self.mentorName = mentorName
        self.mentorProfile = mentorProfile
        self.menteeUID = menteeUID
        self.menteeName = menteeName
    }
}
