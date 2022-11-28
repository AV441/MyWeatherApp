//
//  DateConverter.swift
//  MyWeatherApp
//
//  Created by Андрей on 08.06.2022.
//

import Foundation

final class DateConverter {
    
    private static let formater = DateFormatter()
    
    /// Converts current time to "MM-dd HH:mm" format
    static func convertCurrentTime() -> Date {
        formater.dateFormat = "MM-dd HH:mm"
        let currentTimeString = formater.string(from: .now)
        let currentTime = formater.date(from: currentTimeString)
        
        return currentTime ?? .now
    }
    
    /// Converts given date string to date with "MM-dd HH:mm" format
    static func convertForecastTime(from date: String) -> Date {
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        let dateFromString = formater.date(from: date) ?? .now
        
        formater.dateFormat = "MM-dd HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        let time = formater.date(from: stringFromDate) ?? .now
        
        return time
    }
    
    /// Converts given time string to date with "MM-dd HH:mm" format
    static func convertAstroTime(from timeString: String, with dateString: String) -> Date {
        let dateAndTimeString = "\(dateString) \(timeString)"
        
        formater.dateFormat = "YYYY-MM-dd hh:mm a"
        let date = formater.date(from: dateAndTimeString) ?? .now
        
        formater.dateFormat = "MM-dd HH:mm"
        let string = formater.string(from: date)
        
        return formater.date(from: string) ?? .now
    }
    
    /// Creates "HH:mm" string from the given date or returns "Now"
    static func createTimeString(from date: Date) -> String {
        formater.dateFormat = "HH:mm"
        let currentTime = formater.string(from: .now)
        let time = formater.string(from: date)
        
        return time == currentTime ? "Now" : time
    }
    
    /// Creates "EEE, d MMM" string from the given date string or returns "Today"
    static func createDateString(from date: String) -> String {
        formater.dateFormat = "YYYY-MM-dd"
        let dateFromString = formater.date(from: date)
        let currentDateString = formater.string(from: .now)
        let currentDate = formater.date(from: currentDateString)
        
        formater.dateFormat = "EEE, d MMM"
        formater.locale = Locale(identifier: "en")
        let stringFromDate = formater.string(from: dateFromString ?? .now)
        
        return dateFromString == currentDate ? "Today" : stringFromDate
    }
}
