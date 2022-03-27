//
//  WheatherService.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import Foundation


class WeatherService{
    
    
    
    
    func getWeather(){
        NetworkManager.shared.getRequest(url: "https://api.openweathermap.org/data/2.5/forecast?lat=-12.40&lon=37.785834&appid=8ddadecc7ae4f56fee73b2b405a63659", resultDto: Weather5days.self) { res in
            switch res{
                
            case .success(let data):
                print("gelen data \(data)")
            case .failure(let err):
                print(err)
            }
        }
    }
}
struct dto:Codable{
    let name:String
}
