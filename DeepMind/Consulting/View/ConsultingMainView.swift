//
//  ConsultingMainView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import SwiftUI

struct ConsultingMainView: View {
    var body: some View {
        ZStack{
            LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.5), Color.backgroundColor.opacity(0.7)]), startPoint: .top, endPoint: .bottom).edgesIgnoringSafeArea(.all)
            
            ScrollView{
                VStack{
                    
                }.padding(20)
            }
        }
    }
}

#Preview {
    ConsultingMainView()
}
