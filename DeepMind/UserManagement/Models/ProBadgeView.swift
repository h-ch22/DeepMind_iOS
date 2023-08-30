//
//  ProBadgeView.swift
//  DeepMind
//
//  Created by 하창진 on 8/30/23.
//

import SwiftUI

struct ProBadgeView: View {
    var body: some View {
        Text("PRO")
            .font(.caption)
            .fontWeight(.semibold)
            .foregroundStyle(Color.white)
            .padding(5)
            .background(
                RoundedRectangle(cornerRadius: 5).foregroundStyle(Color.orange)
            )
    }
}

#Preview {
    ProBadgeView()
}
