//
//  HospitalMapView.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/13/23.
//

import SwiftUI

struct HospitalMapController: UIViewControllerRepresentable{
    let bottomBarHeight: CGFloat
    typealias UIViewControllerType = HospitalMapViewController
    
    func makeUIViewController(context: Context) -> HospitalMapViewController {
        return HospitalMapViewController(bottomBarHeight: bottomBarHeight)
    }
    
    func updateUIViewController(_ uiViewController: HospitalMapViewController, context: Context) {
        
    }
}

struct HospitalMapView: View {
    let bottomBarHeight: CGFloat
    
    var body: some View {
        ZStack{
            HospitalMapController(bottomBarHeight: bottomBarHeight)
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    HospitalMapView(bottomBarHeight: 0)
}
