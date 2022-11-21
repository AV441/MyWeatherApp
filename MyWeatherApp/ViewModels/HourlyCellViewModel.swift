//
//  HourlyCellViewModel.swift
//  MyWeatherApp
//
//  Created by Андрей on 16.11.2022.
//

import UIKit

struct HourlyCellViewModel {
    let time: String
    let image: UIImage?
    let chanceOfRain: String
    let temp: String
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

