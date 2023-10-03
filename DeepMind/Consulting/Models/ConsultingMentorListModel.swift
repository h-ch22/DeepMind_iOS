//
//  ConsultingMentorListModel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/3/23.
//

import SwiftUI

struct ConsultingMentorListModel: View {
    let data: MentorInfoModel
    
    var body: some View {
        VStack{
            if data.mentorProfile != nil{
                AsyncImage(url: data.mentorProfile!, content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 80, height: 80)
                        .clipShape(Circle())
                        .shadow(radius: 5)
                }, placeholder: {
                    ProgressView()
                })
            } else{
                Image("ic_appstore")
                    .resizable()
                    .frame(width : 80, height : 80)
                    .clipShape(Circle())
                    .shadow(radius: 5)
            }
            
            Spacer().frame(height: 5)
            
            Text(data.mentorName)
                .fontWeight(.semibold)
                .foregroundStyle(Color.txt_color)
            
            Spacer().frame(height: 5)

            HStack{
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(Color.orange)
                
                Text("\(String(data.rate)) / 5.0")
                    .font(.caption)
                    .foregroundStyle(Color.orange)
            }
        }
    }
}
