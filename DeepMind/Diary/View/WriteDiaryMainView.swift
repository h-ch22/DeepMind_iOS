//
//  WriteDiaryMainView.swift
//  DeepMind
//
//  Created by 하창진 on 8/7/23.
//

import SwiftUI

struct WriteDiaryMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var changeView = false

    var body: some View {
        NavigationView{
            ZStack{
                Color.backgroundColor.edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    
                    HStack{
                        Image(systemName : "pencil")
                        
                        VStack{
                            HStack{
                                Text("오늘의 하루 기록하기")
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }

                            HStack{
                                Text("하루 일기를 작성해서 오늘의 당신을 기록해보세요.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }

                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image(systemName : "calendar")
                        
                        VStack{
                            HStack{
                                Text("돌아보기")
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }

                            HStack{
                                Text("꾸준히 당신의 하루를 기록하고, 당신의 하루들을 돌아보세요.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }

                        }
                    }
                    
                    Spacer().frame(height : 20)
                    
                    HStack{
                        Image(systemName : "chart.xyaxis.line")
                        
                        VStack{
                            HStack{
                                Text("감정 상태 내보내기")
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }

                            HStack{
                                Text("전문가와 심리 상담이 필요한 경우 감정 상태를 PDF로 내보내어 상담의 참고자료로 사용할 수 있습니다.")
                                    .font(.caption)
                                    .foregroundStyle(Color.gray)
                                
                                Spacer()
                            }

                        }
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        self.changeView = true
                    }){
                        HStack{
                            Text("일기 작성하기")
                                .foregroundColor(.white)
                            
                            Image(systemName : "chevron.right")
                                .foregroundColor(.white)
                        }.padding([.vertical], 20)
                            .padding([.horizontal], 120)
                            .background(RoundedRectangle(cornerRadius: 50).foregroundColor(Color.accent).shadow(radius: 5))
                    }
                }
                .padding(20)

            }
            .navigationTitle(Text("하루 일기 작성하기"))
                .toolbar(content: {
                    ToolbarItemGroup(placement: .topBarLeading, content: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark")
                        }
                    })
                })
                .fullScreenCover(isPresented: $changeView, content: {
                    WriteDiaryView()
                })
        }
        .navigationViewStyle(StackNavigationViewStyle())

    }
}

#Preview {
    WriteDiaryMainView()
}
