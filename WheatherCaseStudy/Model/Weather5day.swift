import Foundation

//enum CodingKeys: String, CodingKey {
//        case  main, weather, wind, visibility
//        case dtTxt = "dt_txt"
//
//    }


struct WeeklyWeatherForecast: Codable{
    
    let currentWeather:CurrentWeather
    let dailyWeather:[Weather]
    
    enum CodingKeys : String, CodingKey{
        case dailyWeather = "daily"
        case currentWeather = "current"
    }
   
    
}

struct CurrentWeather:Codable{
    let temperature:Double
    let weather:[WeatherInfo]
    enum CodingKeys : String, CodingKey{
        case temperature = "temp"
        case weather
    }

}
struct WeatherInfo:Codable{
    let main:String
    let description:String
    let icon:String
    
    
}
struct Weather:Codable{
    let temperature:Temperature
    let weatherInfo:[WeatherInfo]
    
    enum CodingKeys : String, CodingKey{
        case temperature = "temp"
        case weatherInfo = "weather"
    }
}

struct Temperature:Codable{
    let day:Double
    let min:Double
    let max:Double
}
