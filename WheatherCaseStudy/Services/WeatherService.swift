//
//  WheatherService.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation
import CoreLocation
import Combine


protocol WeatherServiceProtocol:AnyObject{
    var weeklyForeCast:WeeklyWeatherForecast? {get set}
    func getWeeklyForecast(latitude:CLLocationDegrees,longitude:CLLocationDegrees,ApiKey:String,completion: @escaping (Result<WeeklyWeatherForecast,NetworkingError>)->Void)
    

    
    func newGetWeeklyForecast(latitude:CLLocationDegrees,longitude:CLLocationDegrees,ApiKey:String,completion: @escaping (Result<WeeklyWeatherForecast,NetworkingError>)->Void)
    
    
    ///TEST OPTİONAL FUNC
    
    
    func getWeeklyForecastTest(latitude:CLLocationDegrees,longitude:CLLocationDegrees,ApiKey:String,completion: @escaping (Result<WeeklyWeatherForecast,NetworkingError>)->Void)
}
extension WeatherServiceProtocol{
    func getWeeklyForecastTest(latitude:CLLocationDegrees,longitude:CLLocationDegrees,ApiKey:String,completion: @escaping (Result<WeeklyWeatherForecast,NetworkingError>)->Void){
        
        
        let key = "123"
        
        if ApiKey != key{
            return completion(.failure(NetworkingError.error("key Hatası")))
        }
        
        guard let url = Bundle.main.url(forResource: "MockWeather", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            print("bulunamadı")
            return completion(.failure(NetworkingError.error("Mock json okunamadı")))
        }
        guard let weatherMock = try? JSONDecoder().decode(WeeklyWeatherForecast.self, from: data) else{
            return completion(.failure(NetworkingError.error("Parse hatası")))
        }
        completion(.success(weatherMock))
        
       
       
    }
}


class WeatherService:WeatherServiceProtocol{
    
    @Published var weeklyForeCast:WeeklyWeatherForecast?
    
    var cancellable = Set<AnyCancellable>()
    
    let networkManager:NetworkManagerProtocol
    
    init(networkManager:NetworkManagerProtocol){
        self.networkManager = networkManager
    }
    
    
    func getWeeklyForecastCombine(){
        
        
        networkManager.getRequestCombine(endPointUrl: "")
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
        
        
        
        networkManager.getRequest(url: url) { (result:Result<WeeklyWeatherForecast,NetworkingError>) in
            switch result {
            case .success(let weatherForecast):
                completion(.success(weatherForecast))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    func newGetWeeklyForecast(latitude:CLLocationDegrees,longitude:CLLocationDegrees,ApiKey:String,completion: @escaping (Result<WeeklyWeatherForecast,NetworkingError>) -> Void) {
        
        
        let list = QueryItemsBlock {
            URLQueryItem(name: "lat", value: "\(latitude)")
            URLQueryItem(name: "lon", value: "\(longitude)")
            URLQueryItem(name: "lang", value: "tr")
            URLQueryItem(name: "exclude", value: "hourly,weekly")
            URLQueryItem(name: "appid", value: "\(ApiKey)")
        }

        
             let weatherEndpoint = Endpoint(path: "/data/2.5/onecall", httpMethod: .get, httpTask: .request,queryItems: list.items())
        
        networkManager.newGetRequest(endpoint: weatherEndpoint) { (result:Result<WeeklyWeatherForecast,NetworkingError>) in
            switch result {
            case .success(let weatherForecast):
                completion(.success(weatherForecast))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }

    }
  
}

