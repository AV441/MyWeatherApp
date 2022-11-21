//
//  SearchResponse.swift
//  MyWeatherApp
//
//  Created by Андрей on 14.11.2022.
//

import Foundation

struct SearchResponse: Decodable {
    let name: String
    let country: String
    let lat: Double
    let lon: Double
}
