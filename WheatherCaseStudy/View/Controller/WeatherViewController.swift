//
//  WeatherViewController.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit
import SDWebImage

class WeatherViewController: UIViewController,Storyboarded {
    
    
    
    @IBOutlet weak var WeatherTableView: UITableView!{
        didSet{
            WeatherTableView.delegate = self
            WeatherTableView.dataSource = self
            
        }
    }
    
    
    
    var locationVM:LocationViewModel?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationVM?.delegate = self
        
        WeatherTableView.sectionHeaderHeight = UITableView.automaticDimension
        WeatherTableView.estimatedSectionHeaderHeight = 44
        WeatherTableView.register(UINib(nibName: "WeatherTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "WeatherTableViewHeader")
   
    }

    
    
    

}


extension WeatherViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return locationVM?.weatherList.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherViewCell
      
        if let resultList = locationVM?.weatherList[indexPath.row]{
        cell.DayLabel.text = resultList.dtTxt.getFormattedDate()
            cell.MaxDegree.text = resultList.main.temp_max.convertTemp(from: .kelvin, to: .celsius)
            cell.MinDegree.text = resultList.main.temp_min.convertTemp(from: .kelvin, to: .celsius)
        
       
            cell.WeatherIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/wn/\(resultList.weather[0].icon)@2x.png"), placeholderImage: UIImage(systemName: "person"))
            
            
            
        }
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherTableViewHeader") as! WeatherTableViewHeader
        
        if let vList = locationVM?.weatherList.first{
            header.WeatherIcon.sd_setImage(with: URL(string: "http://openweathermap.org/img/wn/\( vList.weather[0].icon)@2x.png"), placeholderImage: UIImage(systemName: "person"))
          
           
        }
        
        header.CityName.text = locationVM?.cityName
       
        
        header.WeatherDegree.text = locationVM?.weatherList.first?.main.temp.convertTemp(from: .kelvin, to: .celsius)
      
      
        
        
        return header
    }

    
   
    
    
    
}

extension WeatherViewController:WeatherInfoDelegate{
    func receiveWeather(weather: output) {
       
        switch weather {
        case .setLoading(let bool):
            print(bool)
      
         
        case .reloading:
            self.WeatherTableView.reloadData()
        }
    }
    
    
}
