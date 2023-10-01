//
//  HomeCommunityListModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/13/23.
//

import SwiftUI

struct HomeCommunityListModel: View {
    let data: CommunityArticleDataModel
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Text(data.title)
                    .foregroundStyle(Color.txt_color)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Spacer()
                
                Text(String(data.commentCount))
                    .foregroundStyle(Color.accent)
                    .fontWeight(.semibold)
            }

            HStack{
                Text("\(data.nickName)")
                    .font(.caption)
                    .foregroundStyle(Color.gray)
                
                Spacer()

                Text(data.board)
                    .font(.caption)
                    .foregroundStyle(Color.gray)
            }

        }.padding(20)
            .frame(minWidth: 200, maxWidth: 200, minHeight: 80, maxHeight: 80)
            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 5))
    }
}

#Preview {
    HomeCommunityListModel(data: CommunityArticleDataModel(id: "", title: "TITLE", contents: "", imageIndex: 0, author: "", nickName: "NICKNAME", createDate: "DATE", views: 0, commentCount: 0, board: "BOARD", profile: nil, thumbnail: nil))
}
