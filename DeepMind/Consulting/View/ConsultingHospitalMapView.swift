//
//  ConsultingHospitalMapView.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation
import SwiftUI

struct ConsultingHospitalMapView: UIViewControllerRepresentable{
    let location: [Double]
    let hospitalAddress: String
    
    typealias UIViewControllerType = ConsultingHospitalMapViewController
    
    func makeUIViewController(context: Context) -> ConsultingHospitalMapViewController {
        return ConsultingHospitalMapViewController(location: location, hospitalAddress: hospitalAddress)
    }
    
    func updateUIViewController(_ uiViewController: ConsultingHospitalMapViewController, context: Context) {
        
    }
}
