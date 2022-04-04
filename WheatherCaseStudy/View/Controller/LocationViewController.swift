//
//  LocationViewController.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController,Storyboarded{
    
       
    @IBOutlet weak var ApiKey: UITextField!
    
    @IBOutlet weak var LoadingView: UIActivityIndicatorView!
    
    var loactionVM = LocationViewModel(weatherService: WeatherService())
    var cancellable = DisposeBag()
    deinit{
        print("kapandı")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        

        
        
       
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
   
    @IBAction func ApiKeyEnter(_ sender: Any) {
        guard ApiKey.text != nil else {
            print("textfield boş olamaz")
            return
        }
        let accessPage = loactionVM.apiKeyAccessControll(ApiKey: ApiKey.text!)

        if accessPage.0{
            
            let vc = WeatherViewController.instantiate()
            vc.locationVM = loactionVM
            loactionVM.locationWheatherInfo()
            
            navigationController?.pushViewController(vc, animated: true)
        }else{
            print("Ekrana hata bas \(accessPage.1?.localizedDescription)")
        }
        

        
    }
}





//extension LocationViewController:CLLocationManagerDelegate{
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//
////        locationManager.requestWhenInUseAuthorization()
//        switch manager.authorizationStatus {
//        case .authorizedAlways , .authorizedWhenInUse:
//            //düzelt
//            guard let currentLoc:CLLocation = locationManager.location else {
//                return
//            }
//
//            let geoCoder = CLGeocoder()
//            geoCoder.reverseGeocodeLocation(currentLoc, completionHandler: { (placemarks, _) -> Void in
//
//                placemarks?.forEach { (placemark) in
//
//                    if let city = placemark.locality { self.loactionVM.cityName = city } // Prints "New York"
//                }
//            })
//            loactionVM.Latitude = currentLoc.coordinate.latitude
//            loactionVM.Longitude = currentLoc.coordinate.longitude
//        case .notDetermined , .denied , .restricted:
//            break
//        default:
//            break
//        }
//
//        switch manager.accuracyAuthorization {
//        case .fullAccuracy:
//            break
//        case .reducedAccuracy:
//            break
//        default:
//            break
//        }
//    }
//}
