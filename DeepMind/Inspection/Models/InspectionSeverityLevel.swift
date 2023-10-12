//
//  InspectionSeverityLevel.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import SwiftUI

struct InspectionSeverityLevel: View {
    let severity: InspectionSeverityModel
    let color: Color
    
    var body: some View {
        VStack(spacing: 3){
            ForEach((0..<7).reversed(), id: \.self){ level in
                RoundedRectangle(cornerRadius: 5)
                    .frame(width: 20, height: 5)
                    .foregroundStyle(severity.level > level ? color : Color.gray)
            }
        }
    }
}

#Preview {
    InspectionSeverityLevel(
        severity: .HIGHLY_IMPROBABLE,
        color: .accent
    )
}
