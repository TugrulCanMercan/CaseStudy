//
//  WeatherViewCell.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit

class WeatherViewCell: UITableViewCell {
    @IBOutlet weak var DayText: UIView!
    
    @IBOutlet weak var MinDegree: UILabel!
    
    @IBOutlet weak var MaxDegree: UILabel!
    
    @IBOutlet weak var WeatherIcon: UIImageView!
    
    @IBOutlet weak var DayLabel: UILabel!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    func configurationCell(weatherCellModel:WeatherTableCellModel){
        DayLabel.text = weatherCellModel.DayLabel
        MinDegree.text = weatherCellModel.MinDegreee
        MaxDegree.text = weatherCellModel.MaxDegreee
        
        WeatherIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/wn/\(weatherCellModel.WeatherIconName)@2x.png"), placeholderImage: UIImage(systemName: "person"))
    }
    

}
