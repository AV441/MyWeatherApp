//
//  DateConverter.swift
//  MyWeatherApp
//
//  Created by Андрей on 08.06.2022.
//

import Foundation

final class DateConverter {
    
    private static let formater = DateFormatter()
    
    /// Creates "HH:mm" string from the given date
    public static func createTimeString(from date: Date) -> String {
        formater.dateFormat = "HH:mm"
        return formater.string(from: date)
    }
    
    /// ForecastTimeConverter
    public static func convertForecastTimeWithDate(from date: String) -> Date {
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        let dateFromString = formater.date(from: date) ?? .now
        formater.dateFormat = "MM-dd HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        let time = formater.date(from: stringFromDate) ?? .now
        
        return time
    }
    
    public static func convertForecastTimeWithoutDate(from date: String) -> Date {
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        let dateFromString = formater.date(from: date) ?? .now
        formater.dateFormat = "HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        let time = formater.date(from: stringFromDate) ?? .now
        
        return time
    }
    
    public static func convertForecastTimeWithoutDate(from date: Date) -> Date {
        formater.dateFormat = "HH:mm"
        let stringFromDate = formater.string(from: date)
        
        let time = formater.date(from: stringFromDate) ?? .now
        
        return time
    }
    
    public static func convertCurrentTime() -> Date {
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd HH:mm"
        let currentTimeString = formater.string(from: Date.now)
        let currentTime = formater.date(from: currentTimeString)
        
        return currentTime ?? .now
    }
    
    public static func convertAstroTime(from timeString: String, with dateString: String) -> Date {
        
        let dateAndTimeString = "\(dateString) \(timeString)"
       
        formater.dateFormat = "YYYY-MM-dd hh:mm a"
        let date = formater.date(from: dateAndTimeString) ?? .now
        formater.dateFormat = "MM-dd HH:mm"
        let string = formater.string(from: date)
        return formater.date(from: string) ?? .now
    }
    
    /// Convert "YYYY-MM-dd HH:mm" to "HH:mm". This func will only be used in Hourly Section configuration, thats why it could return "Now".
    public static func getTimeFromDate(_ date: String) -> String {
        formater.dateFormat = "YYYY-MM-dd HH:mm"
        guard let dateFromString = formater.date(from: date) else {
            return "Now"
        }
        
        formater.dateFormat = "HH:mm"
        let stringFromDate = formater.string(from: dateFromString)
        
        return stringFromDate
    }
    
    /// 
    static func getDayFromDate(_ date: String) -> String {
        formater.dateFormat = "YYYY-MM-dd"
        let dateFromString = formater.date(from: date)
        formater.dateFormat = "EEE, d MMM"
        formater.locale = Locale(identifier: "en")
        let stringFromDate = formater.string(from: dateFromString ?? .now)
        
        return stringFromDate
    }
}
