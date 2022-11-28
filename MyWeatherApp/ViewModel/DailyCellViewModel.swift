//
//  DailyCellViewModel.swift
//  MyWeatherApp
//
//  Created by Андрей on 16.11.2022.
//

import UIKit

final class DailyCellViewModel {
    
    private var item: DailyItem!
    
    init(_ item: DailyItem) {
        self.item = item
    }
    
    var day: String {
        return DateConverter.createDateString(from: item.forecast.date)
    }
    
    var image: UIImage? {
        let code = item.forecast.day.condition.code
        return ImageGenerator.dayImage(for: code)
    }
    
    var chanceOfRain: String? {
        let chanceOfRain = item.forecast.day.dailyChanceOfRain
        return chanceOfRain == 0 ? nil : "\(chanceOfRain) %"
    }
    
    var minTemp: String {
        return "\(Int(item.forecast.day.minTemp))°"
    }
    
    var maxTemp: String {
        return "\(Int(item.forecast.day.maxTemp))°"
    }
}
