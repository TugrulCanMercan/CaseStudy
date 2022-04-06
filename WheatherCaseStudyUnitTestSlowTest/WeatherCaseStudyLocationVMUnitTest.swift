//
//  WeatherCaseStudyLocationVMUnitTest.swift
//  WheatherCaseStudyUnitTestSlowTest
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 30.03.2022.
//

import XCTest
@testable import WheatherCaseStudy

class WeatherCaseStudyLocationVMUnitTest: XCTestCase {
    
    var VM : LocationViewModel?

    override func setUpWithError() throws {
        self.VM = LocationViewModel(weatherService: WeatherService(),locationService: LocationService())
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
        let weatherService = WeatherService()
        let locService = LocationService()
        
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
    
    
    func test_LocationVM_ApiKey_ShouldBeMockResponse__(){
        
        
        guard let url = Bundle.main.url(forResource: "MockWeather", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            print("bulunamadı")
            return XCTFail()
        }

        
        
        
        guard let weather = try? JSONDecoder().decode(WeeklyWeatherForecast.self, from: data) else {
            return XCTFail()
        }
        
        XCTAssertNotNil(weather)
        
        
    }
    
    func test_LocationVM_ApiKey_LocationService(){
        
        
        
        
        guard let url = Bundle.main.url(forResource: "MockWeather", withExtension: "json"),
        let data = try? Data(contentsOf: url) else {
            print("bulunamadı")
            return XCTFail()
        }

        
        
        
        guard let weather = try? JSONDecoder().decode(WeeklyWeatherForecast.self, from: data) else {
            return XCTFail()
        }
        
        XCTAssertNotNil(weather)
        
        
    }


}
