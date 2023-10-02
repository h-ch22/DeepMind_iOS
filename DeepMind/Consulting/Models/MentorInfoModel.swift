//
//  MentorInfoModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation

struct MentorInfoModel: Hashable{
    var mentorUID: String
    var mentorName: String
    var mentorProfile: URL?
    var hospitalLocation: [Double]?
    var hospitalAddress: String
    var rate: Double
    
    init(mentorUID: String, mentorName: String, mentorProfile: URL?, hospitalLocation: [Double]?, hospitalAddress: String, rate: Double) {
        self.mentorUID = mentorUID
        self.mentorName = mentorName
        self.mentorProfile = mentorProfile
        self.hospitalLocation = hospitalLocation
        self.hospitalAddress = hospitalAddress
        self.rate = rate
    }
}
