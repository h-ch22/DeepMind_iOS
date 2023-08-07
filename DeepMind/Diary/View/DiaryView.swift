//
//  DiaryView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI

struct DiaryView: View {
    @StateObject private var helper = DiaryHelper()
    
    @State private var showProgress = true
    @State private var showError = false
    @State private var showModal = false
    @State private var currentIndex = 0
    @State private var emotions = ["🥰 행복해요", "😆 최고예요", "😀 좋아요", "🙂 그저그래요", "☹️ 안좋아요", "😢 슬퍼요", "😣 혼자있고싶어요", "😡 화나요"]
    @State private var showAlert = false
    
    private func getCodeByEmotion(code: DiaryEmotionModel) -> String{
        switch code{
        case .HAPPY: return emotions[0]
        case .GREAT: return emotions[1]
        case .GOOD: return emotions[2]
        case .SOSO: return emotions[3]
        case .BAD: return emotions[4]
        case .SAD: return emotions[5]
        case .STAY_ALONE: return emotions[6]
        case .ANGRY: return emotions[8]
        }
    }
    
    private func getStringDate() -> (String, String, String?){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy. MM. dd."
        
        let date = dateFormatter.date(from: helper.diaryList[currentIndex].date)
        
        let year = date?.year
        let month = date?.month
        let day = date?.day
        let weekDay = date?.weekDay
        
        return (String("\(year ?? 0)/\(month ?? 0)"), String(day ?? 0), date?.codeToWeekDay(code: weekDay ?? 0))
    }
    
    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                if showProgress{
                    Spacer()
                    
                    ProgressView()
                    
                    Spacer()
                } else if showError{
                    Spacer()
                    
                    Image(systemName : "exclamationmark.circle.fill")
                        .font(.largeTitle)
                        .foregroundStyle(Color.gray)
                    
                    Spacer()
                } else if helper.diaryList.isEmpty{
                    VStack{
                        Spacer()
                        
                        Image(systemName : "square.and.pencil")
                            .font(.title)
                        
                        Text("당신의 하루를 기록해보세요.")
                            .fontWeight(.semibold)
                            .foregroundStyle(Color.gray)
                    }
                } else{
                    ScrollView{
                        VStack{
                            Group{
                                HStack{
                                    Button(action: {
                                        if currentIndex > 0{
                                            currentIndex -= 1
                                            
                                            helper.getURL(id: helper.diaryList[currentIndex].date, imgCount: helper.diaryList[currentIndex].imgCount){ downloadResult in
                                                guard let downloadResult = downloadResult else{return}
                                            }
                                        }
                                    }){
                                        Image(systemName: "chevron.left.circle")
                                            .foregroundStyle(currentIndex == 0 ? Color.gray : Color.accentColor)
                                    }
                                    
                                    Spacer()
                                    
                                    Text(self.getStringDate().1)
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundStyle(Color.txt_color)
                                    
                                    VStack(alignment: .leading){
                                        Text(self.getStringDate().0)
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                        
                                        Text("\(self.getStringDate().2 ?? "")요일")
                                            .font(.caption)
                                            .foregroundStyle(Color.gray)
                                    }
                                    
                                    Spacer()

                                                                        
                                    Button(action: {
                                        if currentIndex < helper.diaryList.count-1{
                                            currentIndex += 1
                                            
                                            helper.getURL(id: helper.diaryList[currentIndex].date, imgCount: helper.diaryList[currentIndex].imgCount){ downloadResult in
                                                guard let downloadResult = downloadResult else{return}
                                            }
                                        }
                                    }){
                                        Image(systemName: "chevron.right.circle")
                                            .foregroundStyle(currentIndex == helper.diaryList.count - 1 ? Color.gray : Color.accentColor)
                                    }
                                }
                            }
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text(AES256Util.decrypt(encoded: helper.diaryList[currentIndex].title))
                                    .font(.custom("KoreanKPNB-R", size: 24))
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                                
                                Text(self.getCodeByEmotion(code: helper.diaryList[currentIndex].emotion))
                                    .font(.custom("KoreanKPNB-R", size: 18))
                                    .foregroundStyle(Color.txt_color)
                            }
                            
                            Spacer().frame(height : 20)
                            
                            HStack{
                                Text(AES256Util.decrypt(encoded: helper.diaryList[currentIndex].contents))
                                    .font(.custom("KoreanKPNB-R", size: 20))
                                    .foregroundStyle(Color.txt_color)
                                
                                Spacer()
                            }
                            
                            if helper.diaryList[currentIndex].imgCount > 0{
                                Spacer().frame(height : 20)
                                
                                ScrollView(.horizontal){
                                    HStack(spacing: 10){
                                        ForEach(helper.urlList, id: \.self){url in
                                            AsyncImage(url: url!){ image in
                                                image
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width : 150, height : 150)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                        }
                                    }
                                }
                            }
                            
                            Spacer()
                        }
                    }
                }
            }.padding(20).onAppear{
                helper.getDiaryList(){ result in
                    guard let result = result else{return}
                    
                    if result{
                        showProgress = false
                        
                        helper.getURL(id: helper.diaryList[0].date, imgCount: helper.diaryList[0].imgCount){ downloadResult in
                            guard let downloadResult = downloadResult else{return}
                        }
                    } else{
                        showProgress = false
                        showError = true
                    }
                }
            }
            .toolbar(content: {
                ToolbarItemGroup(placement: .topBarTrailing, content: {
                    Button(action: {}){
                        Image(systemName : "trash.fill")
                            .foregroundStyle(Color.red)
                    }
                    
                    Button(action: {
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy. MM. dd."
                        
                        if helper.diaryList.contains(where: {$0.date == dateFormatter.string(from: Date())}){
                            self.showAlert = true
                        } else{
                            self.showModal = true
                        }
                    }){
                        Image(systemName: "pencil")
                    }
                })

            })
            .sheet(isPresented: $showModal, content: {
                WriteDiaryMainView()
            })
            .alert(isPresented: $showAlert, content: {
                return Alert(title: Text("경고"), message: Text("하루 일기는 하루에 한번 사용자의 하루 심리 상태를 기록할 수 있도록 설계되었습니다.\n사용자는 이미 오늘 하루 일기를 기록한 것으로 추정됩니다. 계속 진행할 경우 오늘 일기가 제거되고, 새로운 일기로 대체됩니다.\n계속하시겠습니까?"), primaryButton: .default(Text("예")){
                    self.showModal = true
                }, secondaryButton: .default(Text("아니오")))
                
            })
        }
    }
}

#Preview {
    DiaryView()
}
