//
//  WheatherService.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation
import CoreLocation
import Combine


class WeatherService{
    
    @Published var weeklyForeCast:WeeklyWeatherForecast?
    
    var cancellable = Set<AnyCancellable>()
    
    
    
    func getWeeklyForecastCombine(){
        
        
        NetworkManager.shared.getRequestCombine(endPointUrl: "")
            .receive(on: DispatchQueue.main)
            .decode(type: WeeklyWeatherForecast.self, decoder: JSONDecoder())
            .sink { completion in
                switch completion{
                    
                case .finished:
                    print("data başarılı geldi")
                case .failure(let error):
                    print("hata alınd\(error.localizedDescription)")
                }
            } receiveValue: { [weak self] weeklyWeatherForecast in
                guard let self = self else {return}
                self.weeklyForeCast = weeklyWeatherForecast
            }
            .store(in: &cancellable)
    }

    
    func getWeeklyForecast(latitude:CLLocationDegrees,longitude:CLLocationDegrees,ApiKey:String,completion: @escaping (Result<WeeklyWeatherForecast,NetworkingError>)->Void){
        
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&lang=tr&exclude=hourly,weekly&appid=\(ApiKey)"
        NetworkManager.shared.getRequest(url: url) { (result:Result<WeeklyWeatherForecast,NetworkingError>) in
            switch result {
            case .success(let weatherForecast):
                completion(.success(weatherForecast))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    
    
    
    
}









//    "https://api.openweathermap.org/data/2.5/forecast?lat=-12.40&lon=37.785834&appid=8ddadecc7ae4f56fee73b2b405a63659"
    
//https://api.openweathermap.org/data/2.5/onecall?lat=-12.40&lon=37.785834&lang=tr&exclude=hourly,weekly&appid=8ddadecc7ae4f56fee73b2b405a63659 //7 günlük
//    var Longitude:CLLocationDegrees?
//    var Latitude:CLLocationDegrees?
