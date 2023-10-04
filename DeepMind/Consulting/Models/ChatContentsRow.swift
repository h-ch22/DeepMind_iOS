//
//  ChatContentsRow.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/4/23.
//

import SwiftUI

struct ChatContentsRow: View {
    let data : ChatDataModel
    let consultingData: ConsultingDataModel
    
    let profileURL: URL?
    let name: String
    let isMyMSG: Bool

    @State private var msg = ""
    @State private var consonant = ""
    @State private var url = ""
    @State private var msg_split : [Any] = []
    @State private var textStyle = UIFont.TextStyle.body
    @State var redrawPreview = false

    func convertTime() -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd. kk:mm:ss"
        
        let date = dateFormatter.date(from: data.sentTime)
        
        let dateFormatter_modify = DateFormatter()
        dateFormatter_modify.dateFormat = "kk:mm"
                
        return dateFormatter_modify.string(from: date ?? Date())
    }
    
    var body: some View {
        VStack{
            HStack{
                if !isMyMSG{
                    if profileURL != nil{
                        AsyncImage(url: profileURL!, content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width : 25, height : 25)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }, placeholder: {
                            ProgressView()
                        })
                    } else{
                        Image("ic_appstore")
                            .resizable()
                            .frame(width : 25, height : 25)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                    
                    Text(name)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
                
                else{
                    Spacer()
                }
            }
            
            HStack{
                if isMyMSG{
                    Spacer()
                    
                    VStack{
                        Spacer()
                        
                        Text(convertTime())
                            .font(.caption2)
                            .foregroundColor(.gray)
                    }
                }
                
                if data.type == .TEXT{
                    Text(data.message)
                        .padding()
                        .fixedSize(horizontal : false, vertical : true)
                        .background(isMyMSG ? .accent : .gray)
                        .clipShape(ChatBubbleShape(isMyMessage: isMyMSG))
                        .foregroundColor(.white)
                        .onAppear(perform : {
                            let detector = try! NSDataDetector(types : NSTextCheckingResult.CheckingType.link.rawValue)
                            
                            let matches = detector.matches(in: data.message, options: [], range: NSRange(location: 0, length: data.message.utf16.count))
                            
                            for match in matches {
                                guard let range = Range(match.range, in: data.message) else { continue }
                                let url = data.message[range]
                                self.msg = data.message
                                self.url = String(url)
                            }
                        })
                    
                    if !isMyMSG{
                        Spacer().frame(width : 10)
                        
                        VStack {
                            
                            Spacer()
                            
                            Text(convertTime())
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                    }
                    
                }
                
                else if data.type == .IMAGES{
                    if !data.imgs.isEmpty{
                        if data.imgCount == 1{
                            VStack {
                                if data.imgs[0] != nil{
                                    AsyncImage(url: data.imgs[0]!, content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width : 150, height : 150)
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                }
                                
                            }.padding()
                                .background(isMyMSG ? .accent : .gray)
                                .clipShape(ChatBubbleShape(isMyMessage: isMyMSG))
                        } else{
                            var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
                            
                            LazyVGrid(columns : columns){
                                ForEach(data.imgs, id : \.self){ item in
                                    AsyncImage(url: item!, content: { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width : 150, height : 150)
                                            .clipShape(Circle())
                                            .shadow(radius: 5)
                                    }, placeholder: {
                                        ProgressView()
                                    })
                                }
                                
                            }.padding()
                                .background(isMyMSG ? .accent : .gray)
                                .clipShape(ChatBubbleShape(isMyMessage: isMyMSG))
                        }
                        
                        if !isMyMSG{
                            Spacer().frame(width : 10)
                            
                            VStack {
                                Spacer()
                                
                                Text(convertTime())
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            
            if self.url != ""{
                Spacer().frame(height : 20)

                LinkPreviewRow(previewURL : url, redraw : self.$redrawPreview)
            }
            
        }
    }
}
