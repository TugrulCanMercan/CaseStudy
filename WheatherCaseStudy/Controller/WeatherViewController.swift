//
//  WeatherViewController.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit

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

      
        
        
    }

    
    
    

}


extension WeatherViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherViewCell
        
        
        
        
        return cell
    }
    
    
}

extension WeatherViewController:WeatherInfoDelegate{
    func receiveWeather(weather: output) {
        
    }
    
    
}
