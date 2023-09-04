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
                    Text(data.createDate)
                        .font(.caption)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                }
            }
            
            Spacer()
            
            Text(String(data.commentCount))
                .foregroundStyle(Color.accent)
        }.padding(10)
            .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.btn_color).shadow(radius: 3))

    }
}
