//
//  StringConverter.swift
//  MyWeatherApp
//
//  Created by Андрей on 27.11.2022.
//

import Foundation

final class StringConverter {
    
    static func createSafeQueryString(from string: String) -> String {
        let filteredString = string.filter { $0.isLetter || $0.isWhitespace }
        let safeString = filteredString.replacingOccurrences(of: " ", with: "_")
        return safeString
    }
}
