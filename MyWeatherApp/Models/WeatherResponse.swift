//
//  Models.swift
//  MyWeatherApp
//
//  Created by Андрей on 24.05.2022.
//

import Foundation
import UIKit

// Response
struct WeatherResponse: Decodable, Hashable {
    let current: Current
    let forecast: Forecast
}

// Current
struct Current: Decodable, Hashable {
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
struct Forecast: Decodable, Hashable {
    let forecastday: [DailyForecast]
}

struct DailyForecast: Decodable, Hashable {
    let date: String
    let day: Day
    let hour: [HourlyForecast]
    let astro: AstroForecast
}

struct Day: Decodable, Hashable {
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

struct HourlyForecast: Decodable, Hashable {
    
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

struct AstroForecast: Decodable, Hashable {
    let sunrise: String
    let sunset: String
}

struct Condition: Decodable, Hashable {
    let text: String
    let code: WeatherCode
}
