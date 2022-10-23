//
//  Item.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import Foundation

enum Item: Hashable {
    case current(CurrentWeather)
    case hourly(HourlyWeather)
    case daily(DailyForecast)
}

struct CurrentWeather: Hashable {
    var locationName: String
    let weather: Current
}

struct HourlyWeather: Hashable {
    var weatherData: HourlyForecast
    var astroData: AstroForecast?
    var astroKind: AstroKind?
    enum AstroKind: Hashable {
        case isSunrise
        case isSunset
    }
}
