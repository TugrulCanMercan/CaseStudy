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
    
    
    
    weak var locationVM:LocationViewModel?
    

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
      
        if let data = locationVM?.weatherList[indexPath.row]{
            cell.configurationCell(weatherCellModel: data)
        }
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherTableViewHeader") as! WeatherTableViewHeader
        
        if let data = locationVM?.weatherCurrentHeader{
            header.headerConfigration(headerModel: data)
        }
        
        
      
        
        
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
