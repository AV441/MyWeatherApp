//
//  WeatherService.swift
//  MyWeatherApp
//
//  Created by Андрей on 15.11.2022.
//

import Foundation

typealias WeatherDataFetchResult = Result<WeatherResponse, Error>
typealias LocationsFetchResult = Result<[SearchResponse], Error>

/// This class manages weather data requests from API
final class WeatherService {
    
    private let key = "fabdc37da9544f0cad993304222405"
    private let baseUrl = "http://api.weatherapi.com/v1"
    
    /// Requests weather data for the given location coordinates
    public func requestWeatherData(for coordinates: Coordinates, completion: @escaping (WeatherDataFetchResult) -> Void) {
        
        let lat = coordinates.lat
        let lon = coordinates.lon
        
        guard let url = URL(string: "\(baseUrl)/forecast.json?key=\(key)&q=\(lat),\(lon)&days=3&lang=en") else {
            completion(.failure(WeatherServiceErrors.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(WeatherServiceErrors.fetchWeatherError))
                return
            }
            
            if let weatherResponse = self?.parseJSON(from: data, to: WeatherResponse.self) {
                completion(.success(weatherResponse))
            }
        }.resume()
    }
    
    /// Requests weather data for the given location name
    public func requestWeatherData(for location: String, completion: @escaping (WeatherDataFetchResult) -> Void) {

        guard let url = URL(string: "\(baseUrl)/forecast.json?key=\(key)&q=\(location)&days=3&lang=en") else {
            completion(.failure(WeatherServiceErrors.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil, let data = data else {
                completion(.failure(WeatherServiceErrors.fetchWeatherError))
                return
            }
            
            if let weatherResponse = self?.parseJSON(from: data, to: WeatherResponse.self) {
                completion(.success(weatherResponse))
            }
        }.resume()
    }
    
    /// Requests locations for the given query string
    public func searchLocation(_ searchEntry: String, completion: @escaping (LocationsFetchResult) -> Void) {
        
        guard let url = URL(string: "\(baseUrl)/search.json?key=\(key)&q=\(searchEntry)") else {
            completion(.failure(WeatherServiceErrors.urlError))
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error  in
            guard error == nil, let data = data else {
                completion(.failure(WeatherServiceErrors.fetchLocationError))
                return
            }
            
            if let searchResults = self?.parseJSON(from: data, to: [SearchResponse].self) {
                completion(.success(searchResults))
            }
        }.resume()
    }
    
    /// Parses given JSON data into chosen type
    private func parseJSON<T: Decodable>(from data: Data, to type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let parsedData = try decoder.decode(type, from: data)
            return parsedData
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
    
}

fileprivate enum WeatherServiceErrors: Error {
    case urlError
    case fetchWeatherError
    case fetchLocationError
}

extension WeatherServiceErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .urlError:
            return NSLocalizedString("Failed to create url", comment: "")
        case .fetchWeatherError:
            return NSLocalizedString("Failed to fetch weather Data. Check your internet connection", comment: "")
        case .fetchLocationError:
            return NSLocalizedString("Failed to fetch locations. Check your internet connection", comment: "")
        }
    }
}
