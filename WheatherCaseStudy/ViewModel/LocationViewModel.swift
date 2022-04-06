//
//  LocationViewModel.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation
import CoreLocation
import UIKit



/// düzelt
enum LocationViewModelErrorList:String,Error{
    
    case keyHatasi = "Geçersiz api key"
}



class LocationViewModel{
    
    
    ///Publisher Property

    var setLoadingPublisher:Box<Bool> = Box<Bool>(false)
    var weatherCellListPublisher:Box<[WeatherTableCellModel]> = Box<[WeatherTableCellModel]>([])
    var weatherCurrentViewHeaderPublisher:Box<WeatherTableHeaderModel?> = Box<WeatherTableHeaderModel?>(nil)
    
    
    
    
    var Longitude:CLLocationDegrees?
    var Latitude:CLLocationDegrees?
    var cityName:String = ""
    private var ApiKey:String = ""

    var sessionPublisher:Box<String?> = Box<String?>(VKFSession.shared.retrieve(with: .weatherApiKey))
    
    
    private(set) var weatherService:WeatherServiceProtocol
    var locationService:LocationServiceProtocol
    
    var disposebag = DisposeBag()
    
    init(weatherService:WeatherService,locationService:LocationService){
        self.weatherService = weatherService
        
        self.locationService = locationService
        self.observerLocationService()
     
        
       
    }
    
  
    func observerLocationService(){
        locationService.publisher.bind(listener: {[weak self] locationResult in
            guard let self = self else {return}
            self.Longitude = locationResult?.longitude
            self.Latitude = locationResult?.latitude
            self.cityName = locationResult?.city ?? "Şehir ismi gelmedi"
            
        })
        .disposed(by: disposebag)
    }
    
    
    
    
    
    @discardableResult
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
        
        self.setLoadingPublisher.value = true

        weatherService.getWeeklyForecast(latitude: latitude, longitude: longitude, ApiKey: ApiKey) {[weak self] weather in
            
            guard let self = self else {return}
            switch weather{
                
            case .success(let weatherData):
                
                
                
                self.dailyCellList(wether: weatherData)
                self.tableHeaderCurrentForecast(currentWeather: weatherData.currentWeather)
                

                self.setLoadingPublisher.value = false
                
            case .failure(let error):
                print(error)
                

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

    }

}
