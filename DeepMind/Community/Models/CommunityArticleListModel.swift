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
            VStack{
                HStack{
                    Text(data.title)
                        .foregroundStyle(Color.txt_color)
                        .fontWeight(.semibold)
                    
                    Spacer()
                    
                }
                
                HStack{
                    Text(data.nickName)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
                
                HStack{
                    Text("\(data.board)|\(data.createDate)")
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

        }.padding(10)
            

    }
}

struct CommunityArticleListModel_previews: PreviewProvider{
    static var previews: some View{
        CommunityArticleListModel(data: CommunityArticleDataModel(id: "", title: "", contents: "", imageIndex: 0, author: "", nickName: "", createDate: "", views: 0, commentCount: 0, board: ""))
    }
}
