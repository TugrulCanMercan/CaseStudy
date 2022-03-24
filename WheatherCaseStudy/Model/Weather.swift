//
//  Wheater.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation


//{
//    "lat": 33.44,
//    "lon": -94.04,
//    "timezone": "America/Chicago",
//    "timezone_offset": -18000,
//    "current": {
//        "dt": 1648106164,
//        "sunrise": 1648124063,
//        "sunset": 1648168217,
//        "temp": 278.62,
//        "feels_like": 276.55,
//        "pressure": 1014,
//        "humidity": 68,
//        "dew_point": 273.19,
//        "uvi": 0,
//        "clouds": 0,
//        "visibility": 10000,
//        "wind_speed": 2.57,
//        "wind_deg": 340,
//        "weather": [
//            {
//                "id": 800,
//                "main": "Clear",
//                "description": "clear sky",
//                "icon": "01n"
//            }
//        ]

struct Weather:Codable {
    let lat: Double
    let lon: Double
    let timezone:String
    let current:CurrentWeather
    let daily:[DailyWeather]
}

struct DailyWeather:Codable{
    let temp:WeatherTemp
    let weather:[WeatherInfo]
}
struct WeatherTemp:Codable{
    let day:Double
    let min:Double
    let max:Double
    let night:Double
    let eve:Double
    let morn:Double
}

struct CurrentWeather:Codable{
    let temp:Double
    let weather:[WeatherInfo]
}
struct WeatherInfo:Codable{
    let main:String
    let description:String
    let icon:String
}
