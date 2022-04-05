//
//  LocationViewController.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 24.03.2022.
//

import UIKit
import CoreLocation

class LocationViewController: UIViewController,Storyboarded{
    
       
    @IBOutlet weak var ApiKey: UITextField!
    
    
    
    var loactionVM = LocationViewModel(weatherService: WeatherService(),locationService: LocationService())
    var cancellable = DisposeBag()
    deinit{
        print("kapandı")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("NotificationIdentifier"), object: nil)


    }
    @objc func methodOfReceivedNotification(notification: Notification){
        if let key = notification.object as? String{
           
            ApiKey.text = key
            buttonAction(key: key)
        }else{
            print("gelmedi")
        }
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
        
    }
   
    @IBAction func ApiKeyEnter(_ sender: Any) {
     

        guard ApiKey.text != nil else {
            print("textfield boş olamaz")
            return
        }
        
        buttonAction(key: ApiKey.text!)
        
    }
    
    func buttonAction(key:String){
       
        let accessPage = loactionVM.apiKeyAccessControll(ApiKey: key)

        if accessPage.0{
            
            let vc = WeatherViewController.instantiate()
            vc.locationVM = loactionVM
            loactionVM.locationWheatherInfo()
            
            navigationController?.pushViewController(vc, animated: true)
        }else{
            print("Ekrana hata bas \(accessPage.1?.localizedDescription)")
        }
        
    }
}




