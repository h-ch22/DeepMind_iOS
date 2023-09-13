//
//  HospitalMapHelper.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/13/23.
//

import Foundation
import Alamofire
import CoreLocation

class HospitalMapHelper: ObservableObject{
    private let API_KEY = "QcTLK3P7DD%2Fxi31dnkw90ZE2rZ%2BVYvQUHvBcj07az4cXAPri%2BGAPLxrXKm0o50CJwjbzdGxp2PpKwPd7vu026A%3D%3D"
    private let TARGET_URL = "https://apis.data.go.kr/B552657/HsptlAsembySearchService/getHsptlMdcncLcinfoInqire?"
    
    func getHospitalList(latitude: String, longitude: String){
        let url = TARGET_URL + "serviceKey=\(API_KEY)&WGS84_LON=\(longitude)&WGS84_LAT=\(latitude)"
        print(url)
        
        let alamo = AF.request(url, method: .get, parameters: nil, headers: nil)
        alamo.validate().response { data in
            print(data)
        }
    }
}
