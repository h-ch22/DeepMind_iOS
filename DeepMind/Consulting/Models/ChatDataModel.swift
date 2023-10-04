//
//  ChatDataModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import Foundation

struct ChatDataModel: Hashable{
    var id: String
    var sender: String
    var message: String
    var imgCount: Int
    var imgs: [URL?]
    var sentTime: String
    var type: ChatType
    
    init(id: String, sender: String, message: String, imgCount: Int, imgs: [URL?], sentTime: String, type: ChatType) {
        self.id = id
        self.sender = sender
        self.message = message
        self.imgCount = imgCount
        self.imgs = imgs
        self.sentTime = sentTime
        self.type = type
    }
}
