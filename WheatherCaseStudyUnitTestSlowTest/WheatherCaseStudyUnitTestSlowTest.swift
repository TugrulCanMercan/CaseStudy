//
//  WheatherCaseStudyUnitTestSlowTest.swift
//  WheatherCaseStudyUnitTestSlowTest
//
//  Created by Tuğrul Can MERCAN (Dijital Kanallar Uygulama Geliştirme Müdürlüğü) on 30.03.2022.
//

import XCTest
@testable import WheatherCaseStudy
import CoreLocation


class WheatherCaseStudyUnitTestSlowTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_LocationVM_Service_WeatherListCellLoad_ShouldBeLoadList() throws {
        
        //given
        let weatherService = WeatherService()
        let vm = WeatherForeCastViewModel(weatherService: weatherService)
        let mockLatitude:CLLocationDegrees = 20
        let mockLongitude:CLLocationDegrees = 20
        let ApiKey:String = "8ddadecc7ae4f56fee73b2b405a63659"
        let promise = expectation(description: "Data geldi")
        var weatherList:WeeklyWeatherForecast?
        
        //when
        
        
        
        
        
        
        
        vm.weatherService.getWeeklyForecast(latitude: mockLatitude, longitude: mockLongitude, ApiKey: ApiKey) { resultWeather in
            //then
            switch resultWeather{
                
            case .success(let weatherForecastList):
                print(weatherForecastList)
                weatherList = weatherForecastList
                promise.fulfill()
                
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
        }
        wait(for: [promise], timeout: 5)
        XCTAssertNotNil(weatherList)
    }


    
}
