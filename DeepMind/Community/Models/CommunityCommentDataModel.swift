//
//  CommunityCommentDataModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import Foundation

struct CommunityCommentDataModel: Hashable{
    var author: String
    var nickName: String
    var contents: String
    var uploadDate: String
    
    init(author: String, nickName: String, contents: String, uploadDate: String) {
        self.author = author
        self.nickName = nickName
        self.contents = contents
        self.uploadDate = uploadDate
    }
}
