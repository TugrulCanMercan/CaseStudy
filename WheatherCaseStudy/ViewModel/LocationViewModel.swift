//
//  LocationViewModel.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation
import CoreLocation
import UIKit


enum output{
    case setLoading(Bool)
    case reloading
    //    case weatherOutput(weather:Weather5days)
    //    case weatherFiveDays(weather: [List])
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
    var cityName:String = ""
    
    
    
    var weather:Weather5days?{
        didSet{
            guard let weather = weather else {
                return
            }
            
        }
    }
    var weatherIcon:UIImage?
    
    var weatherList:[List] = [] {
        didSet{
            delegate?.receiveWeather(weather: .reloading)

        }
    }
    var ApiKey:String = ""

    init(){
        let service = WeatherService()
        service.getWeather()
    }
    
    func filterWeatherList(weather:Weather5days?){
        
        var weatherListResult:[List] = []
        if let listCount = weather?.list.count {
            for item in 0..<listCount where item % 5 == 0 {
                if let weatherİtem = weather?.list[item]{
                    
                    
                    
                    weatherListResult.append(weatherİtem)
                    
                }
            }
        }
        self.weatherList = weatherListResult
        
    }
    
    
    func locationWheatherInfo(){
        
        
        
        guard let Longitude = Longitude, let Latitude = Latitude else {
            print("enlem boylam gelmedi")
            return
        }
        
        delegate?.receiveWeather(weather: .setLoading(true))

        let endPoint = "https://api.openweathermap.org/data/2.5/forecast?lat=\(Latitude)&lon=\(Longitude)&appid=\(ApiKey)"
        
        NetworkManager.shared.get(url: endPoint) {[weak self] result in
            
            
            switch result{
            case .success(let data):
                
                
                self?.filterWeatherList(weather: data)
                
                
                self?.delegate?.receiveWeather(weather: .setLoading(false))
                
            case .failure(let err):
                print(err)
            }
        }
  
    }

}
