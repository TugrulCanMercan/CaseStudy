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
            let latitude = mostRecentLocation.coordinate.latitude
            let longitude = mostRecentLocation.coordinate.longitude

            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(mostRecentLocation) { (placemarks, error) in
                guard let placemarks = placemarks, let placemark = placemarks.first else { return }
                if let city = placemark.locality,
                   let locationName = placemark.name
                {
                    let responseDTO = LocationAndCity(latitude: latitude, longitude: longitude, city: city, locationName: locationName)
                    self.publisher.value = responseDTO

                }


            }
        }.disposed(by: disposeBag)
    }
}


struct LocationAndCity{
    let latitude:CLLocationDegrees
    let longitude:CLLocationDegrees
    let city : String
    let locationName:String

}
