//
//  CurrentCellViewModel.swift
//  MyWeatherApp
//
//  Created by Андрей on 15.11.2022.
//

import UIKit

final class CurrentCellViewModel {
    
    private var item: CurrentItem!
    
    init(_ item: CurrentItem) {
        self.item = item
    }
    
    var locationName: String {
        return item.location.name
    }
    
    var temp: String {
        return "\(Int(item.current.temp)) °"
    }
    
    var condition: String {
        return item.current.condition.text
    }
    
    var feelsLikeTemp: String {
        return "Feels like \(Int(item.current.feelsLike)) °"
    }

    var image: UIImage? {
        let isDay = item.current.isDay
        let code = item.current.condition.code
        let imageDay = ImageGenerator.dayImage(for: code)
        let imageNight = ImageGenerator.nightImage(for: code)
        return isDay == 1 ? imageDay : imageNight
    }
   
}
