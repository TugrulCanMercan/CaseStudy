//
//  WeatherCaseStudyLocationVMUnitTest.swift
//  WheatherCaseStudyUnitTestSlowTest
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 30.03.2022.
//

import XCTest
@testable import WheatherCaseStudy
import CoreLocation

class WeatherCaseStudyLocationVMUnitTest: XCTestCase {
    
    var VM : LocationViewModel!

    override func setUpWithError() throws {
        
        
        self.VM = LocationViewModel(weatherService: WeatherService(networkManager: NetworkManager.shared),locationService: LocationService(locationManager: LocationManager.shared))
    }

    override func tearDownWithError() throws {
        VM = nil
    }

  
    
    func test_LocationVM_WeatherService_ShouldBeInit(){
        
        guard let VM = VM else {
            XCTFail()
            return
        }
        XCTAssertNotNil(VM)
    }
    func test_LocationVM_WeatherServiceInjection_ShouldBeInit(){
        let weatherService = WeatherService(networkManager: NetworkManager.shared)
        let locService = LocationService(locationManager: LocationManager.shared)
        
        let vm = LocationViewModel(weatherService: weatherService,locationService: locService)
        
        let mirror = Mirror(reflecting: vm)
        
        XCTAssertIdentical(weatherService, mirror.firstChild(named: "weatherService"))
    }
    
    func test_LocationVM_ApiKey_ShouldBeValid(){
        
        
        let GivenKey = "8ddadecc7ae4f56fee73b2b405a63659"
        
        
        guard let VM = VM else {
            XCTFail()
            return
        }

        
        let access = VM.apiKeyAccessControll(ApiKey: GivenKey)
        
        
        XCTAssert(access.0 == true)
        XCTAssertTrue(access.0)
        
        
    }
    
    
    func test_LocationVM_ApiKey_ShouldBeInValid(){
        
        //sadece sayı kontrolü
        let GivenKey = ""
        
        guard let VM = VM else {
            XCTFail()
            return
        }

        
        let access = VM.apiKeyAccessControll(ApiKey: GivenKey)
        
        
        XCTAssert(access.0 == false)
        
        guard let vmErrorList = access.1 as? LocationViewModelErrorList else {
            
            return XCTFail()
        }

        XCTAssert(vmErrorList.rawValue == "Geçersiz api key")
        
        
    }
    
    
    func test_LocationVM_ApiKey_ShouldBeMockResponse(){
        
        
        let latitude:CLLocationDegrees = 10
        let longitude:CLLocationDegrees = 10
        let key = "123"

        VM.weatherService.getWeeklyForecastTest(latitude: latitude, longitude: longitude, ApiKey: key) { result in
            switch result{
                
            case .success(let data):
                
                XCTAssertNotNil(data)
                
            case .failure(let err):
                XCTAssertNil(err)
            }
        }
        
        
   
        
    }
    
    func test_LocationVM_ApiKeyInvalid_ShouldBeKeyError(){
        
        
        let latitude:CLLocationDegrees = 10
        let longitude:CLLocationDegrees = 10
        let key = "123"

        VM.weatherService.getWeeklyForecastTest(latitude: latitude, longitude: longitude, ApiKey: key) { result in
            switch result{
                
            case .success(let data):
                
                XCTAssertNotNil(data)
                
            case .failure(let err):
                XCTAssertNil(err)
            }
        }
        
        
   
        
    }
    
    func test_LocationVM_DailyCellList_ShouldBeLoadList() {
        
        

        guard let url = Bundle.main.url(forResource: "MockWeather", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            print("bulunamadı")
            return XCTFail()
        }

        guard let weather = try? JSONDecoder().decode(WeeklyWeatherForecast.self, from: data) else {
            return XCTFail()
        }
        XCTAssertNotNil(weather)
        
        VM?.dailyCellList(wether: weather)
        
        XCTAssertNotNil(VM?.weatherCellListPublisher.value)
        
        
        
    }
    
    func test_LocationVM_LocationService_ShouldBeLocationEnable(){
        
     
        
        
        let locationManager = MockLocationManager.shared
        
        
        
        _ = locationManager.getAuthorizationStatus()
        let isEnabled = locationManager.isLocationServicesEnabled()

    
        XCTAssertTrue(isEnabled)
      
    }

    
    func test_LocationVM_LocationService_ShouldBeGetLongitude(){
        
     
        let locationManager = MockLocationManager.shared
        _ = LocationViewModel(weatherService: WeatherService(networkManager: NetworkManager.shared), locationService: LocationService(locationManager: LocationManager.shared))
        
        
     
        _ = locationManager.getAuthorizationStatus()
        let isEnabled = locationManager.isLocationServicesEnabled()

        
    
        XCTAssertTrue(isEnabled)
      
    }
    
    func test_LocationVM_MockLocationManager_ShouldBeLocation(){
        let mockLocManager:LocationManagerProtocol = MockLocationManager.shared
        
        var long:CLLocationDegrees?
        var lat:CLLocationDegrees?
        
        var cancellable:Disposable? = mockLocManager.currentLocationPublisher.bind {loc in
            
            
            long = loc?.coordinate.longitude
            lat = loc?.coordinate.latitude
            
        }
        cancellable = nil
        cancellable?.dispose()
        

        XCTAssertNotNil(long)
        XCTAssert(long == -10)
        XCTAssert(lat == 10)

    }
    
    func test_LocationVM_TableHeaderCurrentForecast_ShouldBeLoadHeader(){
        
        guard let url = Bundle.main.url(forResource: "MockWeather", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            print("bulunamadı")
            return XCTFail()
        }

        guard let weather = try? JSONDecoder().decode(WeeklyWeatherForecast.self, from: data) else {
            return XCTFail()
        }
        XCTAssertNotNil(weather)
        
        VM?.tableHeaderCurrentForecast(currentWeather: weather.currentWeather)
        
        XCTAssertNotNil(VM?.weatherCurrentViewHeaderPublisher.value)
    }

}



