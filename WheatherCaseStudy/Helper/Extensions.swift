//
//  Extensions.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 25.03.2022.
//

import Foundation


extension Double{
    
    
    func convertTemp(from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        let mf = MeasurementFormatter()
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: self, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
      }
    
}




extension String {
   func getFormattedDate() -> String {

       let dateFormatterGet = DateFormatter()
       dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"

       let dateFormatter = DateFormatter()
       dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
       

       let date: Date? = dateFormatterGet.date(from: self)
       let result = dateFormatter.string(from: date!)
       return result
    }
}
