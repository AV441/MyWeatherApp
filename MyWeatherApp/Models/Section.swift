//
//  Section.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import Foundation
import UIKit

enum Section: Hashable, CaseIterable {
    case current 
    case hourly
    case daily
}

enum SectionHeaderType: String {
    case hourly = "24 HOURS FORECAST"
    case daily = "3 DAY FORECAST"
    
    var image: UIImage? {
        switch self {
        case .hourly:
            return UIImage(systemName: "clock")
        case .daily:
            return UIImage(systemName: "calendar")
        }
    }
}
