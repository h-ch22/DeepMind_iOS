//
//  StatisticsView.swift
//  DeepMind
//
//  Created by 하창진 on 7/30/23.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    @StateObject private var inspectionHelper = InspectionHelper()
    @State private var currentIndex = 0
    @State private var categories = ["HTP 검사", "하루일기", "하루감정"]


    var body: some View {
        ZStack{
            Color.backgroundColor.edgesIgnoringSafeArea(.all)
            
            VStack{
                Picker("", selection : $currentIndex){
                    ForEach(categories.indices, id:\.self){category in
                        Text(categories[category])
                    }
                }.pickerStyle(.segmented)
                
                Spacer().frame(height : 20)
                
                if currentIndex != 0{

                } else{
                    Text("HTP 검사를 진행하고 통계를 확인해보세요.")
                        .foregroundStyle(Color.gray)
                }
                
                Spacer()
            }.padding(20)
                .onAppear{

                }
        }
    }
}

#Preview {
    StatisticsView()
}
