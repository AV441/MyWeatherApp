//
//  WeatherItems.swift
//  MyWeatherApp
//
//  Created by Андрей on 28.11.2022.
//

import Foundation

struct CurrentItem {
    let location: Location
    let current: Current
}

struct DailyItem {
    let forecast: DailyForecast
}

struct HourlyItem {
    let time: Date
    let astroData: AstroData?
    let weatherData: HourlyForecast?

    enum AstroData {
        case isSunrise
        case isSunset
    }
}
