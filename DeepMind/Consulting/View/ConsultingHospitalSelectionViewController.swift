//
//  ConsultingHospitalSelectionViewController.swift
//  DeepMind
//
//  Created by Ha Changjin on 10/2/23.
//

import Foundation
import UIKit
import SwiftUI
import NMapsMap
import CoreLocation
import Alamofire
import SwiftyJSON

class ConsultingHospitalSelectionViewController : UIViewController, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    var naverMapView : NMFNaverMapView!
    let marker = NMFMarker()
    let receiver : HospitalLocationReceiver
    let dragListener : HospitalSelectionMapDragListener
    let camPositionFormat = "(%.5f, %.5f) / %.2f / %.2f / %.2f"
    private let API_KEY = "m2fgi65ft3"
    private let API_SECRET = "JWQTZhd2sn0vbWaQ0Jjeob5uSf6QlWNYwErGqUPX"
    private let RGC_URL = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?"
    
    init(receiver : HospitalLocationReceiver, dragListener : HospitalSelectionMapDragListener){
        self.receiver = receiver
        self.dragListener = dragListener
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
                
        naverMapView = NMFNaverMapView(frame : view.frame)
        naverMapView.mapView.addCameraDelegate(delegate: self)
        
        naverMapView.showZoomControls = true
        naverMapView.showCompass = true
        naverMapView.showScaleBar = false
        naverMapView.showIndoorLevelPicker = true
        naverMapView.showLocationButton = false
        naverMapView.mapView.isIndoorMapEnabled = false
        naverMapView.mapView.positionMode = .compass
        naverMapView.mapView.logoAlign = .rightTop
        naverMapView.mapView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 200, right: 0)

        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = UIColor.accent
        marker.captionText = "병원 정보"
        marker.captionColor = UIColor.accent
        
        marker.subCaptionText = ""
        
        view.addSubview(naverMapView)
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
            
            let cameraUpdate = NMFCameraUpdate(scrollTo: NMGLatLng(lat: locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                                                   lng: locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989))
            
            naverMapView.mapView.moveCamera(cameraUpdate)
            
            marker.position = NMGLatLng(lat: locationManager.location?.coordinate.latitude as? Double ?? 35.84690631294601,
                                        lng: locationManager.location?.coordinate.longitude as? Double ?? 127.12938865558989)
            
            marker.mapView = naverMapView.mapView
        }
        
        else{
            
        }
        
    }
    
    func reverseGeocode(lat : String, lng : String){
        let header_key = HTTPHeader(name : "X-NCP-APIGW-API-KEY-ID", value : API_KEY)
        let header_secret = HTTPHeader(name: "X-NCP-APIGW-API-KEY", value: API_SECRET)
        let headers = HTTPHeaders([header_key, header_secret])
        
        let lat_double = Double(lat)!
        let lng_double = Double(lng)!
                
        let parameters : Parameters = [
            "coords" : "\(lng_double),\(lat_double)",
            "output" : "json",
            "orders" : "addr,admcode,roadaddr"
        ]
        
        let alamo = AF.request(RGC_URL, method: .get, parameters: parameters, headers: headers)
        
        alamo.validate().responseJSON(){response in
                switch response.result{
                case .success(let value as [String : Any]):
                    let json = JSON(value)
                    let data = json["results"]
                    let state = data[0]["region"]["area1"]["name"].string ?? ""
                    let address = data[0]["region"]["area2"]["name"].string ?? ""
                    let address_detail = data[0]["region"]["area3"]["name"].string ?? ""
                    let roadName = data[2]["land"]["name"].string ?? ""
                    let road = data[2]["land"]["number1"].string ?? ""
                    var roadCode = data[2]["land"]["number2"].string ?? ""
                    let building = data[2]["land"]["addition0"]["value"].string ?? ""
                    
                    if roadCode != ""{
                        roadCode = "-" + roadCode
                    }
                    
                    self.marker.subCaptionText = state + " " + address + " " + address_detail + "\n" + roadName + " " + road + roadCode + " " + building
                    self.receiver.address = state + " " + address + " " + address_detail + "\n" + roadName + " " + road  +  roadCode + " " + building
                    
                case .failure(let error) :
                    print(error)
                    
                    return
                    
                default:
                    fatalError()
                }
                
            }
    }
}

extension ConsultingHospitalSelectionViewController: NMFMapViewCameraDelegate {
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        let camPosition = mapView.cameraPosition
        
        if !dragListener.isDraging{
            dragListener.isDraging = true
        }
        
        marker.position = NMGLatLng(lat : camPosition.target.lat, lng : camPosition.target.lng)
        marker.subCaptionText = String(camPosition.target.lat) + ", " + String(camPosition.target.lng)
        receiver.location = String(camPosition.target.lat) + ", " + String(camPosition.target.lng)
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let camPosition = mapView.cameraPosition
        
        if !dragListener.isDraging{
            dragListener.isDraging = true
        }
        marker.position = NMGLatLng(lat : camPosition.target.lat, lng : camPosition.target.lng)
        marker.subCaptionText = String(camPosition.target.lat) + ", " + String(camPosition.target.lng)
        receiver.location = String(camPosition.target.lat) + ", " + String(camPosition.target.lng)
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        let camPosition = mapView.cameraPosition
        
        if dragListener.isDraging{
            dragListener.isDraging = false
        }
        
        marker.position = NMGLatLng(lat : camPosition.target.lat, lng : camPosition.target.lng)
        marker.subCaptionText = String(camPosition.target.lat) + ", " + String(camPosition.target.lng)
        receiver.location = String(camPosition.target.lat) + ", " + String(camPosition.target.lng)
        
        reverseGeocode(lat: String(camPosition.target.lat), lng: String(camPosition.target.lng))
    }
}
