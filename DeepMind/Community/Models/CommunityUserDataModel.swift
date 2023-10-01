//
//  CommunityUserDataModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/1/23.
//

import Foundation

struct CommunityUserDataModel: Hashable{
    var uid: String
    var nickName: String
    var profile: URL?
    
    init(uid: String, nickName: String, profile: URL? = nil) {
        self.uid = uid
        self.nickName = nickName
        self.profile = profile
    }
}
