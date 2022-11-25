//
//  Section.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import Foundation

enum Section: Hashable, CaseIterable {
    case current 
    case hourly
    case daily
}

enum SectionHeaderType: String {
    case hourly = "24 HOURS FORECAST"
    case daily = "3 DAY FORECAST"
}
