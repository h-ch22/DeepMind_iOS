//
//  CheckBox.swift
//  DeepMind
//
//  Created by 하창진 on 2023/07/30.
//

import SwiftUI

struct CheckBox: View {
    @Binding var checked: Bool
    let title: String
    
    var body: some View {
        HStack{
            Image(systemName: checked ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(Color.accentColor)
            
            Spacer().frame(width: 5)
            
            Text(title)
                .foregroundStyle(Color.txt_color)
        }.onTapGesture {
            self.checked.toggle()
        }
    }
}
