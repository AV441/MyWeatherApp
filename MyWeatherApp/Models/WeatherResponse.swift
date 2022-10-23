//
//  Models.swift
//  MyWeatherApp
//
//  Created by Андрей on 24.05.2022.
//

import Foundation
import UIKit

struct WeatherResponse: Codable, Hashable {
    let current: Current
    let forecast: Forecast
}

// Current
struct Current: Codable, Hashable {
    let temp: Double
    let isDay: Int
    let feelsLike: Double
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp_c"
        case isDay = "is_day"
        case feelsLike = "feelslike_c"
        case condition
    }
}
// Forecast
struct Forecast: Codable, Hashable {
    let forecastday: [DailyForecast]
}

struct DailyForecast: Codable, Hashable {
    let date: String
    let day: Day
    let hour: [HourlyForecast]
    let astro: AstroForecast
}

struct Day: Codable, Hashable {
    let minTemp: Double
    let maxTemp: Double
    let dailyChanceOfRain: Int
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case minTemp = "mintemp_c"
        case maxTemp = "maxtemp_c"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
    }
}

struct HourlyForecast: Codable, Hashable {
    
    let time: String
    let temp: Double
    let isDay: Int
    let chanceOfRain: Int
    let condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case time
        case temp = "temp_c"
        case isDay = "is_day"
        case chanceOfRain = "chance_of_rain"
        case condition
    }
}

struct AstroForecast: Codable, Hashable {
    let sunrise: String
    let sunset: String
}

struct Condition: Codable, Hashable {
    let text: String
    let code: WeatherCode
}
