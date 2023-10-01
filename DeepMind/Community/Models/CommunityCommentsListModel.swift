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
                if data.profile != nil{
                    AsyncImage(url: data.profile!, content: { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 30, height: 30)
                            .clipShape(Circle())
                    }, placeholder: {
                        ProgressView()
                    })
                } else{
                    Image("ic_appstore")
                        .resizable()
                        .frame(width : 30, height : 30)
                        .clipShape(Circle())
                }
                
                Spacer().frame(width: 10)
                
                Text(data.nickName)
                    .foregroundStyle(Color.txt_color)
                    .fontWeight(.semibold)
                
                if creatorUID == data.author{
                    Text("작성자")
                        .font(.caption)
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
            
            HStack{
                Text(data.contents)
                    .foregroundStyle(Color.txt_color)
                
                Spacer()
            }

        }
    }
}

#Preview {
    CommunityCommentsListModel(data: CommunityCommentDataModel(author: "", nickName: "sss", contents: "ssss", uploadDate: "date", profile: nil), creatorUID: "")
}
