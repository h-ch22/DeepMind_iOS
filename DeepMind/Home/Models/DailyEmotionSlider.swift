//
//  DailyEmotionSlider.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/30/23.
//

import SwiftUI

struct DailyEmotionSlider: View {
    @Binding var percentage: Double
    @Binding var color: Color
    
    @State private var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 0...100
    
    var body: some View {
        GeometryReader{ geometry in
            let cursorSize = geometry.size.height * 0.8
            let radius = geometry.size.height * 0.5
            let minValue = geometry.size.width * 0.015
            let maxValue = (geometry.size.width * 0.98) - cursorSize
            
            let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
            let lower = sliderRange.lowerBound
            let sliderVal = (self.percentage - lower) * scaleFactor + minValue
            
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: radius)
                    .foregroundStyle(color)
                    .shadow(radius: 3)
                
                HStack{
                    Circle()
                        .foregroundStyle(Color.white)
                        .frame(width: cursorSize, height: cursorSize)
                        .offset(x: sliderVal)
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged{ v in
                                    if (abs(v.translation.width) < 0.1){
                                        self.lastCoordinateValue = sliderVal
                                    }
                                    
                                    if v.translation.width > 0{
                                        let nextCoordinationValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                        self.percentage = ((nextCoordinationValue - minValue) / scaleFactor) + lower
                                    } else{
                                        let nextCoordinationValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                        self.percentage = ((nextCoordinationValue - minValue) / scaleFactor) + lower
                                    }
                                }
                        )
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    DailyEmotionSlider(percentage: .constant(1.0), color: .constant(Color.orange))
}
