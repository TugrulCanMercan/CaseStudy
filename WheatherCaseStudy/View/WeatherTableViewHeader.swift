//
//  WeatherTableViewHeader.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit

class WeatherTableViewHeader: UITableViewHeaderFooterView {


    @IBOutlet weak var CityName: UILabel!
    
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    @IBOutlet weak var WeatherDegree: UILabel!
    
    
    
    func headerConfigration(headerModel:WeatherTableHeaderModel){
        self.CityName.text = headerModel.CityName
        self.WeatherIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/wn/\(headerModel.WeatherIconName)@2x.png"), placeholderImage: UIImage(systemName: "person"))
        self.WeatherDegree.text = headerModel.WeatherDegree
        
    }
}
