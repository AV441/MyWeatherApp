//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by Андрей on 15.11.2022.
//

import UIKit

typealias WeatherDataFetchResult = Result<WeatherResponse, Error>
typealias LocationsFetchResult = Result<[SearchResponse], Error>

/// This class manages weather data requests from API
final class WeatherService {
    
    private let key = "fabdc37da9544f0cad993304222405"
    
    /// Requests weather data for the given coordinates
    public func requestWeatherData(for coordinates: Coordinates, completion: @escaping (WeatherDataFetchResult) -> Void) {
        
        let lat = coordinates.lat
        let lon = coordinates.lon
        
        // Create url
        guard let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=\(key)&q=\(lat),\(lon)&days=3&lang=en") else {
            completion(.failure(WeatherServiceErrors.urlError))
            return
        }
        
        // create data task
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let fetchedWeatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let weatherResponse = fetchedWeatherData
                    completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Requests weather data for the given location name
    public func requestWeatherData(for location: String, completion: @escaping (WeatherDataFetchResult) -> Void) {
        
        // Create url
        guard let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=\(key)&q=\(location)&days=3&lang=en") else {
            completion(.failure(WeatherServiceErrors.urlError))
            return
        }
        
        // create data task
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let fetchedWeatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                let weatherResponse = fetchedWeatherData
                    completion(.success(weatherResponse))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    /// Requests locations for the given query string
    public func searchLocation(_ searchEntry: String, completion: @escaping (LocationsFetchResult) -> Void) {
        
        let url = URL(string: "http://api.weatherapi.com/v1/search.json?key=\(key)&q=\(searchEntry)")!

        URLSession.shared.dataTask(with: url) { data, response, error  in
            
            guard error == nil, let data = data else {
                completion(.failure(error!))
                return
            }
            
            do {
                let searchResponse = try JSONDecoder().decode([SearchResponse].self, from: data)
                let searchResults = searchResponse
                completion(.success(searchResults))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
}

enum WeatherServiceErrors: LocalizedError {
    case urlError
    case fetchError
}
