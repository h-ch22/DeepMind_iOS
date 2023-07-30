//
//  CheckBox_w.swift
//  DeepMind
//
//  Created by 하창진 on 2023/07/30.
//

import SwiftUI

struct CheckBox_w: View {
    @Binding var checked: Bool
    let title: String

    var body: some View {
        Image(systemName: checked ? "checkmark.circle.fill" : "circle")
            .foregroundColor(checked ? Color.white : Color.accentColor)
    }
}
