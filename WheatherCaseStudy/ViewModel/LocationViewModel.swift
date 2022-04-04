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
/// düzelt
enum LocationViewModelErrorList:String,Error{
    
    case keyHatasi = "Geçersiz api key"
}



class LocationViewModel:WeatherInfoProtocol{
    
    
    ///Publisher Property

    var setLoadingPublisher:Box<Bool> = Box<Bool>(false)
    var weatherCellListPublisher:Box<[WeatherTableCellModel]> = Box<[WeatherTableCellModel]>([])
    var weatherCurrentViewHeaderPublisher:Box<WeatherTableHeaderModel?> = Box<WeatherTableHeaderModel?>(nil)
    
    
    weak var delegate: WeatherInfoDelegate?
    
    var Longitude:CLLocationDegrees?
    var Latitude:CLLocationDegrees?
    var cityName:String = ""
    private var ApiKey:String = ""
    
    // ESKİ
  

//    var weatherWeeklyForecast:WeeklyWeatherForecast?{
//        didSet{
//            delegate?.receiveWeather(weather: .reloading)
//        }
//    }
//    var weatherList:[WeatherTableCellModel] = []{
//        didSet{
//            delegate?.receiveWeather(weather: .reloading)
//        }
//    }
//    
//    var weatherCurrentHeader:WeatherTableHeaderModel?{
//        didSet{
//            delegate?.receiveWeather(weather: .reloading)
//        }
//    }
    //
    
    private(set) var weatherService:WeatherService
    var locationService:LocationService?
    
    var disposebag = DisposeBag()
    
    init(weatherService:WeatherService){
        self.weatherService = weatherService
        self.locationService = LocationService()
        self.observerLocationService()
    }
    
    
    func observerLocationService(){
        locationService?.publisher.bind(listener: {[weak self] locationResult in
            guard let self = self else {return}
            self.Longitude = locationResult?.longitude
            self.Latitude = locationResult?.latitude
            self.cityName = locationResult?.city ?? "Şehir ismi gelmedi"
            
        })
        .disposed(by: disposebag)
    }
    
    
    
    
    
    
    func apiKeyAccessControll(ApiKey:String)->(Bool,Error?){
        
        
        let ApikeyCount = "8ddadecc7ae4f56fee73b2b405a63659".count
        
    
        if ApiKey.count == ApikeyCount {
            self.ApiKey = ApiKey
            return (true,nil)
        }else{
            print("geçersiz api key")
            return (false,LocationViewModelErrorList.keyHatasi)
        }
    }
    
    
    func locationWheatherInfo(){
        
        
        
        guard let longitude = Longitude, let latitude = Latitude else {
            print("enlem boylam gelmedi")
            return
        }
        //DELEGATE
        self.setLoadingPublisher.value = true
//        delegate?.receiveWeather(weather: .setLoading(true))
        weatherService.getWeeklyForecast(latitude: latitude, longitude: longitude,ApiKey: ApiKey) {[weak self] weather in
            
            guard let self = self else {return}
            switch weather{
                
            case .success(let weatherData):
                
                
                
                self.dailyCellList(wether: weatherData)
                self.tableHeaderCurrentForecast(currentWeather: weatherData.currentWeather)
                //DELEGATE
//                self?.delegate?.receiveWeather(weather: .setLoading(false))
                self.setLoadingPublisher.value = false
                
            case .failure(let error):
                print(error)
                //DELEGATE
//                self?.delegate?.receiveWeather(weather: .setLoading(false))
                self.setLoadingPublisher.value = false
            }
        }
        
        
    }
    
    
    
    
    
    private func tableHeaderCurrentForecast(currentWeather:CurrentWeather){
        var headerModel = WeatherTableHeaderModel(CityName: cityName, WeatherDegree: "", WeatherIconName: "")
        
        headerModel.WeatherDegree = currentWeather.temperature.convertTemp(from: .kelvin, to: .celsius)
        if let iconName = currentWeather.weather.first?.icon {
            headerModel.WeatherIconName = iconName
        }

        
        
        self.weatherCurrentViewHeaderPublisher.value = headerModel
//        self.weatherCurrentHeader = headerModel
        
    }
    
    
    private func dailyCellList(wether:WeeklyWeatherForecast){
        
        var cellModel = WeatherTableCellModel(MinDegreee: "", MaxDegreee: "", DayLabel: "", WeatherIconName: "nil")
        
        let WeatherCellModel =  zip(Date.oneWeek, wether.dailyWeather).map { (day,dailyWeather) -> WeatherTableCellModel in
          
            cellModel.MaxDegreee = dailyWeather.temperature.max.convertTemp(from: .kelvin, to: .celsius)
            cellModel.MinDegreee = dailyWeather.temperature.min.convertTemp(from: .kelvin, to: .celsius)
          
            cellModel.DayLabel = day.getFormattedDate()
            
            
            
            if let weatherInformation = dailyWeather.weatherInfo.first {
                cellModel.WeatherIconName = weatherInformation.icon
            }
            return cellModel
        }

        self.weatherCellListPublisher.value = WeatherCellModel
//        self.weatherList = WeatherCellModel
    }

}
