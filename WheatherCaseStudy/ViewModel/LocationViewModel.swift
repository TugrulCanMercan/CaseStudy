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
    
    var ApiKey:String = ""

    var weatherWeeklyForecast:WeeklyWeatherForecast?{
        didSet{
            delegate?.receiveWeather(weather: .reloading)
        }
    }
    var weatherList:[WeatherTableCellModel] = []{
        didSet{
            delegate?.receiveWeather(weather: .reloading)
        }
    }
    
    var weatherCurrentHeader:WeatherTableHeaderModel?{
        didSet{
            delegate?.receiveWeather(weather: .reloading)
        }
    }
    
    
    let weatherService:WeatherService
    
    
    
    init(){
        self.weatherService = WeatherService()
    }
    
    
    
    
    func locationWheatherInfo(){
        
        
        
        guard let Longitude = Longitude, let Latitude = Latitude else {
            print("enlem boylam gelmedi")
            return
        }
        delegate?.receiveWeather(weather: .setLoading(true))
        weatherService.getWeeklyForecast(latitude: Latitude, longitude: Longitude) {[weak self] weather in
            switch weather{
                
            case .success(let weatherData):
                
                
                
                self?.dailyCellList(wether: weatherData)
                self?.tableHeaderCurrentForecast(currentWeather: weatherData.currentWeather)
                self?.delegate?.receiveWeather(weather: .setLoading(false))
            case .failure(let error):
                print(error)
                self?.delegate?.receiveWeather(weather: .setLoading(false))
            }
        }
        
        
    }
    
    func tableHeaderCurrentForecast(currentWeather:CurrentWeather){
        var headerModel = WeatherTableHeaderModel(CityName: cityName, WeatherDegree: "", WeatherIconName: "")
        
        headerModel.WeatherDegree = currentWeather.temperature.convertTemp(from: .kelvin, to: .celsius)
        if let iconName = currentWeather.weather.first?.icon {
            headerModel.WeatherIconName = iconName
        }

        
        
        
        self.weatherCurrentHeader = headerModel
        
    }
    
    
    func dailyCellList(wether:WeeklyWeatherForecast){
        
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

        self.weatherList = WeatherCellModel
    }

}
