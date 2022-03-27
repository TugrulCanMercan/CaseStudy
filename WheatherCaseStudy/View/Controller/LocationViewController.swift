//
//  LocationViewController.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController{
    var locationManager : CLLocationManager!
       
    @IBOutlet weak var ApiKey: UITextField!
    

    var loactionVM = LocationViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        
        
        

        
        
       
    }

   
    @IBAction func ApiKeyEnter(_ sender: Any) {
        guard ApiKey.text != nil else {
            print("textfield boş olamaz")
            return
        }
        
        loactionVM.ApiKey = ApiKey.text!
        loactionVM.locationWheatherInfo()
        let vc = WeatherViewController.instantiate()
        vc.locationVM = loactionVM
        
        navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
 
    
}


//extension LocationViewController:WeatherInfoDelegate{
////    func receiveWeather(weather: output) {
////        switch weather {
////        case .setLoading(let bool):
////            print(bool)
////
////
////        case .reloading:
////
////        }
////    }
//
//
//}

extension LocationViewController:CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        
        locationManager.requestWhenInUseAuthorization()
        switch manager.authorizationStatus {
        case .authorizedAlways , .authorizedWhenInUse:
            //düzelt
            let currentLoc:CLLocation = locationManager.location!
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLoc, completionHandler: { (placemarks, _) -> Void in

                placemarks?.forEach { (placemark) in

                    if let city = placemark.locality { self.loactionVM.cityName = city } // Prints "New York"
                }
            })
            loactionVM.Latitude = currentLoc.coordinate.latitude
            loactionVM.Longitude = currentLoc.coordinate.longitude
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
