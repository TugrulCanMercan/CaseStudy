//
//  Date+Extension.swift
//  WheatherCaseStudy
//
//  Created by Tuğrulcan on 27.03.2022.
//

import Foundation


extension Date{
    
    static var oneWeek:[Self]{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let days = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            .filter { !calendar.isDateInWeekend($0) }
        return days
    }
    
    
    func currentWeeklyDays()->[Self]{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let dayOfWeek = calendar.component(.weekday, from: today)
        let days = calendar.range(of: .weekday, in: .weekOfYear, for: today)!
            .compactMap { calendar.date(byAdding: .day, value: $0 - dayOfWeek, to: today) }
            .filter { !calendar.isDateInWeekend($0) }
        return days
    }
}
