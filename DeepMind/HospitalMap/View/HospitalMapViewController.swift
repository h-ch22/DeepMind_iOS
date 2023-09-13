//
//  HospitalMapViewController.swift
//  DeepMind
//
//  Created by Ha Changjin on 9/13/23.
//

import Foundation
import UIKit
import NMapsMap
import SwiftUI
import CoreLocation

class HospitalMapViewController: UIViewController, CLLocationManagerDelegate{
    var locationManager = CLLocationManager()
    var naverMapView : NMFNaverMapView!
    let bottomBarHeight: CGFloat
    
    init(bottomBarHeight: CGFloat){
        self.bottomBarHeight = bottomBarHeight
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - (bottomBarHeight * 2))
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()

        naverMapView = NMFNaverMapView(frame : view.frame)
        
        naverMapView.showZoomControls = true
        naverMapView.showLocationButton = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = true
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showLocationButton = true
        naverMapView.mapView.isIndoorMapEnabled = true
        naverMapView.mapView.positionMode = .compass
        naverMapView.mapView.logoAlign = .rightTop
        
        view.addSubview(naverMapView)

        if CLLocationManager.locationServicesEnabled(){
            self.locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: self.locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                                                   lng: self.locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            
            self.naverMapView.mapView.moveCamera(cameraUpdate)
            
            DispatchQueue.global().async{
                let helper = HospitalMapHelper()
                helper.getHospitalList(latitude: String(self.locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601), longitude: String(self.locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            }
        }
    }
}
