//
//  HourlyCellViewModel.swift
//  MyWeatherApp
//
//  Created by Андрей on 16.11.2022.
//

import UIKit

final class HourlyCellViewModel {
    
    private var item: HourlyItem!
    
    init(_ item: HourlyItem) {
        self.item = item
    }
    
    var time: String {
        return DateConverter.createTimeString(from: item.time)
    }
    
    var chanceOfRain: String? {
        if let weather = item.weatherData {
            return weather.chanceOfRain == 0 ? nil : "\(weather.chanceOfRain) %"
        } else {
            return nil
        }
    }
    
    var temp: String? {
        if let astroData = item.astroData {
            switch astroData {
            case .isSunrise:
                return "Sunrise"
            case .isSunset:
                return "Sunset"
            }
        }
        
        if let weather = item.weatherData {
            return "\(Int(weather.temp)) °"
        }
        
        return nil
    }
    
    var image: UIImage? {
        if let astroData = item.astroData {
            switch astroData {
            case .isSunrise:
                return ImageGenerator.sunriseImage
            case .isSunset:
                return ImageGenerator.sunsetImage
            }
        }
        
        if let weather = item.weatherData {
            let code = weather.condition.code
            let isDay = weather.isDay
            let dayImage = ImageGenerator.dayImage(for: code)
            let nightImage = ImageGenerator.nightImage(for: code)
            return isDay == 1 ? dayImage : nightImage
        }
        
        return nil
    }
    
}
