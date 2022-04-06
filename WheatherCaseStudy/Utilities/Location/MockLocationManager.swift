//
//  MockLocationManager.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 6.04.2022.
//

import Foundation
import CoreLocation


protocol BaseLocationManagerProtocol {

    // CLLocationManager Properties
    var location: CLLocation? { get }
    var delegate: CLLocationManagerDelegate? { get set }
    var distanceFilter: CLLocationDistance { get set }
    var pausesLocationUpdatesAutomatically: Bool { get set }
    var allowsBackgroundLocationUpdates: Bool { get set }

    // CLLocationManager Methods
    func requestWhenInUseAuthorization()
    func startUpdatingLocation()
    func stopUpdatingLocation()
    
    
    func getAuthorizationStatus() -> CLAuthorizationStatus
    func isLocationServicesEnabled() -> Bool
}
extension CLLocationManager:BaseLocationManagerProtocol{
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return self.authorizationStatus
    }
    
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
    
   
    
}

class MockLocationManager: BaseLocationManagerProtocol {
 

    var location: CLLocation? = CLLocation(
        latitude: 37.3317,
        longitude: -122.0325086
    )

    var delegate: CLLocationManagerDelegate?
    var distanceFilter: CLLocationDistance = 10
    var pausesLocationUpdatesAutomatically = false
    var allowsBackgroundLocationUpdates = true

    func requestWhenInUseAuthorization() { }
    func startUpdatingLocation() { }
    func stopUpdatingLocation() { }
    
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return .authorizedWhenInUse
    }
    
    func isLocationServicesEnabled() -> Bool {
        return true
    }
    
}
