//
//  LocationManager.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.04.2022.
//

import Foundation
import CoreLocation


class LocationManager:NSObject{
    
    
    static var shared:LocationManager = LocationManager()
    var locationManager : CLLocationManager!
    
    var currentLiveLocationPublisher:Box<[CLLocation]> = Box<[CLLocation]>([])
    var currentLocationPublisher:Box<CLLocation?> = Box<CLLocation?>(nil)

    
    private override init(){
        super.init()
        self.locationManager = CLLocationManager()
        authorizationUseRequestManagement()
        startUpdateLocationManagement()
        locationManager.delegate = self
    }
    
    func startUpdateLocationManagement(){
        locationManager.startUpdatingLocation()
        
    }
    
    func stopUpdateLocationManagement(){
        locationManager.stopUpdatingLocation()
    }
    
    func authorizationUseRequestManagement(){
        locationManager.requestWhenInUseAuthorization()
    }
    
 
}

extension LocationManager:CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        currentLiveLocationPublisher.value = locations
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            
            guard let currentLoc:CLLocation = locationManager.location else {
                return
            }
            
            currentLocationPublisher.value = currentLoc

        case .notDetermined , .denied , .restricted:
            break
        default:
            break
        }
        
        switch manager.accuracyAuthorization {
        case .fullAccuracy:
            break
        case .reducedAccuracy:
            break
        default:
            break
        }
    }
}
