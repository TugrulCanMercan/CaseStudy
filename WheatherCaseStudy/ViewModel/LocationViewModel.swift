//
//  LocationViewModel.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation
import CoreLocation


enum output{
    case setLoading(Bool)
    case weatherOutput(weather:Weather)
}


protocol WeatherInfoDelegate:AnyObject{
    func receiveWeather(weather: output)
}

protocol WeatherInfoProtocol{
    var delegate:WeatherInfoDelegate? {get set}
}


class LocationViewModel:WeatherInfoProtocol{
    
    weak var delegate: WeatherInfoDelegate?

    var Longitude:CLLocationDegrees?
    var Latitude:CLLocationDegrees?
   
    
   
    
    func locationWheatherInfo(Longitude:CLLocationDegrees,Latitude:CLLocationDegrees,ApiKey:String){
        
        delegate?.receiveWeather(weather: .setLoading(true))
        let endPoint = "https://api.openweathermap.org/data/2.5/onecall?lat=\(Latitude)&lon=\(Longitude)&exclude=weekly&appid=\(ApiKey)"
       
        NetworkManager.shared.get(url: endPoint) {[weak self] result in
            
            
            switch result{
            case .success(let data):
                
                self?.delegate?.receiveWeather(weather: .weatherOutput(weather: data))
                self?.delegate?.receiveWeather(weather: .setLoading(false))
                print(data)
            case .failure(let err):
                print(err)
            }
        }
        
        
    }
    
    
    
    
    
    
}


struct dto:Codable{
    
}
