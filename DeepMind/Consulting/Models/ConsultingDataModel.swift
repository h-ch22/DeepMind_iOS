//
//  ConsultingDataModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation

struct ConsultingDataModel: Hashable{
    var consultingID: String
    var mentorUID: String
    var menteeUID: String
    var mentorName: String
    var menteeName: String
    var consultingTitle: String
    var consultingContents: String
    var files: [URL]?
    
    init(consultingID: String, mentorUID: String, menteeUID: String, mentorName: String, menteeName: String, consultingTitle: String, consultingContents: String, files: [URL]?) {
        self.consultingID = consultingID
        self.mentorUID = mentorUID
        self.menteeUID = menteeUID
        self.mentorName = mentorName
        self.menteeName = menteeName
        self.consultingTitle = consultingTitle
        self.consultingContents = consultingContents
        self.files = files
    }
}
