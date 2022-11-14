//
//  Networking.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit
import CoreLocation

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    public func requestWeatherData(for coordinates: CLLocationCoordinate2D, completion: @escaping (WeatherResponse) -> Void) {
        
        let lat = coordinates.latitude
        let lon = coordinates.longitude
        
        let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=fabdc37da9544f0cad993304222405&q=\(lat),\(lon)&days=3&lang=ru")!
        
        URLSession.shared.dataTask(with: url) { data, response, error  in
            guard error == nil, let data = data else {
                return
            }
            
            do {
                let fetchedWeatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let results = fetchedWeatherData
                completion(results)
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
