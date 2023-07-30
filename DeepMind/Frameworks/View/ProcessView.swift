//
//  ProcessView.swift
//  DysarthriaChecker
//
//  Created by 하창진 on 2023/07/06.
//

import SwiftUI

struct ProcessView: View {
    var body: some View {
        ProgressView()
            .padding(20)
            .background(RoundedRectangle(cornerRadius: 15).foregroundColor(.btn_color).opacity(0.7))
    }
}

#Preview {
    ProcessView()
}
