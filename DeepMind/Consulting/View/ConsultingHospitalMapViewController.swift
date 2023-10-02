//
//  ConsultingHospitalMapViewController.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation
import UIKit
import NMapsMap

class ConsultingHospitalMapViewController: UIViewController{
    var naverMapView: NMFNaverMapView!
    let location: [Double?]
    let hospitalAddress: String
    let marker = NMFMarker()
    
    init(location: [Double?], hospitalAddress: String){
        self.location = location
        self.hospitalAddress = hospitalAddress
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder){
        fatalError("init(coder:) has not been implemented.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.frame = CGRect(x: 0, y: 0, width: 350, height: 250)
        
        naverMapView = NMFNaverMapView(frame: view.frame)
        naverMapView.showZoomControls = false
        naverMapView.showCompass = false
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showLocationButton = false
        naverMapView.mapView.isIndoorMapEnabled = true
        naverMapView.mapView.logoAlign = .leftBottom
        naverMapView.mapView.moveCamera(
            NMFCameraUpdate(scrollTo: NMGLatLng(lat: location[0]!, lng: location[1]!))
        )

        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.accent
        marker.captionText = hospitalAddress
        marker.captionColor = UIColor.accent
        marker.position = NMGLatLng(lat: location[0]!, lng: location[1]!)
        marker.mapView = naverMapView.mapView
        
        view.addSubview(naverMapView)
    }
}
