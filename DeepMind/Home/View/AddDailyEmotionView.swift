//
//  AddDailyEmotionView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/30/23.
//

import SwiftUI

struct AddDailyEmotionView: View {
    @State private var percentage: Double = 75
    @State private var color = Color.cyan
    @State private var emotions = ["🥰 행복해요", "😆 최고예요", "😀 좋아요", "🙂 그저그래요", "☹️ 안좋아요", "😢 슬퍼요", "😣 혼자있고싶어요", "😡 화나요"]
    @State private var emoji = "🙂"
    @State private var emotion = "그저그래요"
    @State private var selectedIndex = 3
    @State private var showAlert = false
    @State private var showProgress = false
    @State private var helper = HealthDataHelper()
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            ZStack{
                LinearGradient(gradient: Gradient(colors: [color.opacity(0.7), Color.backgroundColor]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
                
                VStack{
                    Spacer()
                    
                    Text(emoji)
                        .font(.largeTitle)
                    
                    Text(emotion)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.white)

                    Spacer()
                    
                    DailyEmotionSlider(percentage: $percentage, color: $color)
                        .frame(width:.infinity, height:50)
                    
                    Spacer()
                    
                    if showProgress{
                        ProgressView()
                    } else{
                        Button(action: {
                            showProgress = true
                            
                            helper.uploadDailyEmotion(emotion: DiaryHelper.indexToEmotion(index: selectedIndex) ?? .SOSO){ result in
                                guard let result = result else{return}
                                
                                if !result{
                                    showAlert = true
                                } else{
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                                
                                showProgress = false
                            }
                        }){
                            HStack{
                                Text("감정 기록하기")
                                    .foregroundStyle(Color.white)
                            }.frame(width: 250, height: 50)
                                .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(color))

                        }
                    }
                    

                }
            }.navigationTitle(Text("하루 감정 기록하기"))
                .toolbar{
                    ToolbarItem(placement: .topBarLeading, content: {
                        Button(action: {
                            self.presentationMode.wrappedValue.dismiss()
                        }){
                            Image(systemName: "xmark")
                        }
                    })
                }
                .alert(isPresented: $showAlert, content: {
                    return Alert(title: Text("오류"), message: Text("요청하신 작업을 처리하는 중 문제가 발생했습니다.\n네트워크 상태, 정상 로그인 여부를 확인하거나 나중에 다시 시도하십시오."), dismissButton: .default(Text("확인")))
                })
                .animation(.easeInOut)
                .onChange(of: self.percentage){ (newVal) in
                    if newVal <= 12.5{
                        color = Color.red
                        selectedIndex = 7
                    } else if newVal <= 25{
                        color = Color.blue
                        selectedIndex = 6
                    } else if newVal <= 37.5{
                        color = Color.gray
                        selectedIndex = 5
                    } else if newVal <= 50{
                        color = Color.orange
                        selectedIndex = 4
                    } else if newVal <= 62.5{
                        color = Color.cyan
                        selectedIndex = 3
                    } else if newVal <= 75{
                        color = Color.yellow
                        selectedIndex = 2
                    } else if newVal <= 87.5{
                        color = Color.pink.opacity(0.6)
                        selectedIndex = 1
                    } else if newVal <= 100{
                        color = Color.pink
                        selectedIndex = 0
                    }
                    
                    let newEmotion = emotions[selectedIndex].split(separator: " ")
                    emoji = String(newEmotion[0])
                    emotion = String(newEmotion[1])
                }

        }.navigationViewStyle(StackNavigationViewStyle())

    }
}

#Preview {
    AddDailyEmotionView()
}
