//
//  DateConverter.swift
//  MyWeatherApp
//
//  Created by Андрей on 08.06.2022.
//

import Foundation

final class DateConverter {
    
    /// ForecastTimeConverter
    static func convertForecastTimeWithDate(from date: String) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        guard let dateFromString = formater.date(from: date) else { return nil }
        formater.dateFormat = "MM-dd HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        let time = formater.date(from: stringFromDate)
        
        return time
    }
    
    static func convertForecastTimeWithoutDate(from date: String) -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        guard let dateFromString = formater.date(from: date) else { return nil }
        formater.dateFormat = "HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        let time = formater.date(from: stringFromDate)
        
        return time
    }
    
    /// CurrentTimeConverter
    static func convertCurrentTime() -> Date? {
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd HH:mm"
        let currentTimeString = formater.string(from: Date.now)
        let currentTime = formater.date(from: currentTimeString)
        
        return currentTime
    }
    
    /// AstroTimeConverter
    static func convertAstroTime(from state: String) -> (Date, String)? {
        let formater = DateFormatter()
        formater.dateFormat = "hh:mm a"
        formater.locale = Locale(identifier: "en_US_POSIX")
        guard let date = formater.date(from: state) else { return nil }
        formater.dateFormat = "HH:mm"
        let astroTimeString = formater.string(from: date)
        guard let astroTimeDate = formater.date(from: astroTimeString) else { return nil }
        
        return (astroTimeDate, astroTimeString)
    }
    
    /// Convert "YYYY-MM-dd HH:mm" to "HH:mm". This func will only be used in Hourly Section configuration, thats why it could return "Сейчас".
    static func getTimeFromDate(_ date: String) -> String {
        
        let formater = DateFormatter()
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        guard let dateFromString = formater.date(from: date) else { return "Сейчас" }
        formater.dateFormat = "HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        
        return stringFromDate
    }
}
