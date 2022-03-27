import Foundation


struct Weather5days: Codable {
    
    
    let list: [List]
    let city: City
}

// MARK: - City
struct City: Codable {
    
    let name: String
    
    let country: String
    let population, timezone, sunrise, sunset: Int
}



// MARK: - List
struct List: Codable {
    
    let main: MainClass
    let weather: [Weather]
    
    let wind: Wind
    let visibility: Int
    
    
    let dtTxt: String
    

    enum CodingKeys: String, CodingKey {
        case  main, weather, wind, visibility
        case dtTxt = "dt_txt"
        
    }
}

struct MainClass:Codable{
    let temp:Double
    let temp_min:Double
    let temp_max:Double
}

struct Weather:Codable{
    let main:String
    let description:String
    let icon:String
}

struct Wind:Codable{
    let speed:Double
}

