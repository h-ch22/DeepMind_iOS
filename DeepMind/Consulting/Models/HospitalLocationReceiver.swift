//
//  HospitalLocationReceiver.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation

class HospitalLocationReceiver: ObservableObject{
    @Published var location = ""
    @Published var address = ""
}
