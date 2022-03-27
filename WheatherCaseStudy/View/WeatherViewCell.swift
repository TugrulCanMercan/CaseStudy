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

    

}
