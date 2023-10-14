//
//  CommunityArticleListModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/4/23.
//

import SwiftUI

struct CommunityArticleListModel: View {
    let data: CommunityArticleDataModel
    
    var body: some View {
        HStack{
            if data.thumbnail != nil{
                AsyncImage(url: data.thumbnail, content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }, placeholder: {
                    ProgressView()
                })
            }
            
            VStack{
                HStack{
                    Text(data.title)
                        .foregroundStyle(Color.txt_color)
                        .fontWeight(.semibold)
                    
                    if data.fileNum > 0{
                        Spacer().frame(width: 5)
                        
                        Image(systemName: "paperclip")
                            .foregroundStyle(Color.accent)
                    }
                    
                    Spacer()
                    
                }
                
                HStack{
                    Text(data.nickName)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
                
                HStack{
                    Text("\(data.board) | \(data.createDate)")
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            ZStack(alignment: .center){
                Image(systemName: "bubble.left.fill")
                    .resizable()
                    .frame(width: 35, height: 35)
                    .foregroundStyle(Color.accent)
                
                Text(String(data.commentCount))
                    .foregroundStyle(Color.white)
            }

        }
            

    }
}

struct CommunityArticleListModel_previews: PreviewProvider{
    static var previews: some View{
        CommunityArticleListModel(data: CommunityArticleDataModel(id: "", title: "", contents: "", imageIndex: 0, author: "", nickName: "", createDate: "", views: 0, commentCount: 0, board: "", profile: nil, thumbnail: nil))
    }
}
