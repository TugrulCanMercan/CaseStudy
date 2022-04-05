//
//  LocationService.swift
//  WheatherCaseStudy
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 4.04.2022.
//

import Foundation
import CoreLocation


class LocationService{
    let disposeBag = DisposeBag()
    
    var publisher:Box<LocationAndCity?> = Box<LocationAndCity?>(nil)
    
    
    init(){
        getCurrentLocationAndCity()
    }
    
    func getCurrentLocationAndCity(){
        
        LocationManager.shared.currentLocationPublisher.bind { [weak self] locationCoordinateList in
            
            guard let self = self else {return}
            guard let mostRecentLocation = locationCoordinateList else {
                return
            }

            
            self.loadLocationAndCityObserv(mostRecentLocation: mostRecentLocation)
            
        }.disposed(by: disposeBag)
    }
    
    
    func loadLocationAndCityObserv(mostRecentLocation: CLLocation){
        
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(mostRecentLocation) {[weak self] (placemarks, error) in
            guard let self = self else {return}
            guard let placemarks = placemarks, let placemark = placemarks.first else { return }
            if let city = placemark.locality,
               let locationName = placemark.name
            {
                let responseDTO = LocationAndCity(latitude: mostRecentLocation.coordinate.latitude, longitude: mostRecentLocation.coordinate.longitude, city: city, locationName: locationName)
                self.publisher.value = responseDTO
                
            }
            
            
        }
    }
}


struct LocationAndCity{
    let latitude:CLLocationDegrees
    let longitude:CLLocationDegrees
    let city : String
    let locationName:String
    
}
