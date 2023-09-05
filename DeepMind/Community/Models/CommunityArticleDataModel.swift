//
//  CommunityArticleDataModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import Foundation

struct CommunityArticleDataModel: Hashable{
    var id: String
    var title: String
    var contents: String
    var imageIndex: Int
    var author: String
    var nickName: String
    var createDate: String
    var views: Int
    var commentCount: Int
    var board: String
    
    init(id: String, title: String, contents: String, imageIndex: Int, author: String, nickName: String, createDate: String, views: Int, commentCount: Int, board: String) {
        self.id = id
        self.title = title
        self.contents = contents
        self.imageIndex = imageIndex
        self.author = author
        self.nickName = nickName
        self.createDate = createDate
        self.views = views
        self.commentCount = commentCount
        self.board = board
    }
}
