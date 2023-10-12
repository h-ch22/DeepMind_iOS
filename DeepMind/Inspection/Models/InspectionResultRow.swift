//
//  InspectionResultRow.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/10/23.
//

import SwiftUI

struct InspectionResultRow: View {
    let title: String
    let severity: InspectionSeverityModel
    
    private func getColor() -> Color{
        switch severity {
        case .HIGHLY_LIKELY:
            return .red
        case .MODERATELY_LIKELY:
            return .pink
        case .LIKELY:
            return .orange
        case .EVEN_ODDS:
            return .yellow
        case .NOT_VERY_LIKELY:
            return .accent
        case .IMPROBABLE:
            return .blue
        case .HIGHLY_IMPROBABLE:
            return .green
        }
    }
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .fontWeight(.semibold)
                    .foregroundStyle(Color.txt)
                
                Text(severity.rawValue)
                    .foregroundStyle(getColor())
                    .font(.caption)
            }

            
            Spacer()
            
            InspectionSeverityLevel(severity: severity, color: getColor())
        }
    }
}

#Preview {
    InspectionResultRow(
        title: "title", severity: .EVEN_ODDS
    )
}
