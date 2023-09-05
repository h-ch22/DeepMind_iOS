//
//  CommunityCommentsListModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/5/23.
//

import SwiftUI

struct CommunityCommentsListModel: View {
    let data: CommunityCommentDataModel
    let creatorUID: String
    
    var body: some View {
        VStack{
            HStack{
                Text(data.nickName)
                    .foregroundStyle(Color.txt_color)
                    .fontWeight(.semibold)
                
                if creatorUID == data.author{
                    Text("작성자")
                        .font(.headline)
                        .padding(5)
                        .foregroundStyle(Color.white)
                        .background(RoundedRectangle(cornerRadius: 50).foregroundStyle(Color.accent))
                }
                
                Spacer()
                
                Text(data.uploadDate)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }
            
            Spacer().frame(height: 10)
            
            Text(data.contents)
                .foregroundStyle(Color.txt_color)
        }
    }
}

#Preview {
    CommunityCommentsListModel(data: CommunityCommentDataModel(author: "", nickName: "sss", contents: "ssss", uploadDate: "date"), creatorUID: "")
}
