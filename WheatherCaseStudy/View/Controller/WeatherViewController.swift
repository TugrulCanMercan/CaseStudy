//
//  WeatherViewController.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit
import SDWebImage

class WeatherViewController: UIViewController,Storyboarded {
    
    
    
    @IBOutlet weak var weatherTableView: UITableView!{
        didSet{
            weatherTableView.delegate = self
            weatherTableView.dataSource = self
            
        }
    }
    
    
    
    weak var locationVM:LocationViewModel?
    var cancellable = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        weatherTableView.sectionHeaderHeight = UITableView.automaticDimension
        weatherTableView.estimatedSectionHeaderHeight = 44
        weatherTableView.register(UINib(nibName: "WeatherTableViewHeader", bundle: nil), forHeaderFooterViewReuseIdentifier: "WeatherTableViewHeader")
        listeningViewModel()
        
    }
    
    
    private func listeningViewModel(){
        locationVM?.weatherCellListPublisher.bind(listener: {[weak self] weatherTableCellModel in
            
            guard let self = self else {return}
            
            self.weatherTableView.reloadData()
        })
        .disposed(by: cancellable)
        locationVM?.weatherCurrentViewHeaderPublisher.bind(listener: { [weak self] weatherTableHeaderModel in
            self?.weatherTableView.reloadData()
        })
        .disposed(by: cancellable)
    }
    
    
    
    
}


extension WeatherViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
       
        return locationVM?.weatherCellListPublisher.value.count ?? 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weatherCell") as! WeatherViewCell
        
        
        locationVM?.weatherCellListPublisher.bind(listener: { weatherList in
            cell.configurationCell(weatherCellModel: weatherList[indexPath.row])
        }).disposed(by: cancellable)

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "WeatherTableViewHeader") as! WeatherTableViewHeader
        
        locationVM?.weatherCurrentViewHeaderPublisher.bind(listener: { weatherTableHeaderModel in
            
            if let data = weatherTableHeaderModel{
                header.headerConfigration(headerModel: data)
            }
            
            
        })
        .disposed(by: cancellable)
        

        return header
    }
    
    
    
    
    
    
}

//extension WeatherViewController:WeatherInfoDelegate{
//    func receiveWeather(weather: output) {
//        
//        switch weather {
//        case .setLoading(let bool):
//            print(bool)
//            
//            
//        case .reloading:
//            self.weatherTableView.reloadData()
//        }
//    }
//    
//    
//}
