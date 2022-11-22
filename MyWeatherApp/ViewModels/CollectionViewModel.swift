//
//  WeatherViewModel.swift
//  MyWeatherApp
//
//  Created by Андрей on 15.11.2022.
//

import UIKit

final class CollectionViewModel: NSObject {
    private var locationService = LocationService()
    private var weatherService = WeatherService()
    
    public var updateCollectionView: () -> Void = {}
    public var updateTableView: () -> Void = {}
    public var updateBackground: ((Int) -> Void)?
        
    public var locations = [SearchResponse]()
    
    public var currentCellViewModels = [CurrentCellViewModel]()
    public var hourlyCellViewModels = [HourlyCellViewModel]()
    public var dailyCellViewModels = [DailyCellViewModel]()
    
    override init() {
        super.init()
        getWeatherDataForCurrentLocation()
    }
    
    /// Requests weather data for the current location and updates collection view
    public func getWeatherDataForCurrentLocation() {
        locationService.updateLocation { [weak self] result in
            switch result {
                
            case .success(let coordinates):
                self?.weatherService.requestWeatherData(for: coordinates) { [weak self] result in
                    switch result {
                        
                    case .success(let weatherData):
                        self?.createCellViewModels(from: weatherData) { [weak self] _ in
                                self?.updateCollectionView()
                            }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// Requests locations for the given query string and updates table view
    public func searchLocation(query: String) {
        weatherService.searchLocation(query) { [weak self] result in
            switch result {
                
            case .success(let locations):
                self?.locations = locations
                self?.updateTableView()
                
            case .failure(let error):
                print("Failed to get locations: \(error.localizedDescription)")
            }
        }
    }
    
    /// Requests weather data for the given location name and updates collection view
    public func getWeatherData(for locationName: String) {
        
        weatherService.requestWeatherData(for: locationName) { [weak self] result in
            switch result {
                
            case .success(let weatherData):
                UserDefaults.standard.set(locationName, forKey: "lastLocation")
                
                self?.createCellViewModels(from: weatherData) { [weak self] _ in
                    let isDay = weatherData.current.isDay
                    self?.updateBackground?(isDay)
                    self?.updateCollectionView()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// Creates cell view models for collection view
    private func createCellViewModels(from weatherData: WeatherResponse, completion: (Bool) -> Void) {
        
        createCurrentCellViewModels(from: weatherData) { [weak self] currentCellViewModels in
                self?.currentCellViewModels = currentCellViewModels
        }
        
        createHourlyItems(from: weatherData) { [weak self] hourlyItems in
            self?.createHourlyViewModels(from: hourlyItems) { [weak self] hourlyCellViewModels in
                self?.hourlyCellViewModels = hourlyCellViewModels
            }
        }
        
        createDailyCellViewModels(from: weatherData) { [weak self] dailyCellViewModels in
            self?.dailyCellViewModels = dailyCellViewModels
        }
        
        completion(true)
    }
    
    /// Creates current cell view models
    private func createCurrentCellViewModels(from weatherResponse: WeatherResponse, completion: ([CurrentCellViewModel]) -> Void) {
        
        var currentCellViewModels = [CurrentCellViewModel]()
        
        let locationName = weatherResponse.location.name
        let temp = "\(Int(weatherResponse.current.temp)) °"
        let condition = weatherResponse.current.condition.text
        let feelsLikeTemp = "Feels like \(Int(weatherResponse.current.feelsLike)) °"
        
        var image: UIImage?
        
        if weatherResponse.current.isDay == 1 {
            image = weatherResponse.current.condition.code.imageDay
        } else {
            image = weatherResponse.current.condition.code.imageNight
        }
        
        let currentCellViewModel = CurrentCellViewModel(locationName: locationName,
                                                        temp: temp,
                                                        image: image,
                                                        condition: condition,
                                                        feelsLikeTemp: feelsLikeTemp)
        currentCellViewModels.append(currentCellViewModel)
        completion(currentCellViewModels)
    }
    
    /// Creates hourly items
    private func createHourlyItems(from weatherResponse: WeatherResponse, completion: ([HourlyItem]) -> Void) {
        
        var hourlyItems = [HourlyItem]()
        let currentTime = DateConverter.convertCurrentTime()
        
        let firstItem = HourlyItem(time: .now,
                                   astroData: nil,
                                   weatherData: HourlyForecast(time: "Now",
                                                               temp: weatherResponse.current.temp,
                                                               isDay: weatherResponse.current.isDay,
                                                               chanceOfRain: 0,
                                                               condition: weatherResponse.current.condition))
        
        for i in 0...1 {
            let sunriseTimeString = weatherResponse.forecast.forecastday[i].astro.sunrise
            let sunsetTimeString = weatherResponse.forecast.forecastday[i].astro.sunset
            let forecastDateString = weatherResponse.forecast.forecastday[i].date
            
            
            let sunriseTime = DateConverter.convertAstroTime(from: sunriseTimeString, with: forecastDateString)
            let sunsetTime = DateConverter.convertAstroTime(from: sunsetTimeString, with: forecastDateString)
            
            let sunriseItem = HourlyItem(time: sunriseTime,
                                         astroData: .isSunrise,
                                         weatherData: nil)
            
            let sunsetItem = HourlyItem(time: sunsetTime,
                                        astroData: .isSunset,
                                        weatherData: nil)
            
                hourlyItems.append(sunriseItem)
                hourlyItems.append(sunsetItem)
            
            let hourlyWeather = weatherResponse.forecast.forecastday[i].hour
            
            hourlyWeather.forEach {
                let time = DateConverter.convertForecastTimeWithDate(from: $0.time)
                let weatherItem = HourlyItem(time: time,
                                             astroData: nil,
                                             weatherData: $0)
                
                if time >= currentTime {
                    hourlyItems.append(weatherItem)
                }
            }
        }
        
        hourlyItems = hourlyItems.filter { $0.time >= currentTime }
        hourlyItems = hourlyItems.sorted(by: { $0.time < $1.time })
        hourlyItems.insert(firstItem, at: 0)
        hourlyItems.removeSubrange(27...hourlyItems.count - 1)
        
        completion(hourlyItems)
    }
    
    /// creates hourly cell view models using hourly items
    private func createHourlyViewModels(from hourlyItems: [HourlyItem], completion: ([HourlyCellViewModel]) -> Void) {
        
        var hourlyViewModels = [HourlyCellViewModel]()
        
        for item in hourlyItems {
            if let astroData = item.astroData {
                switch astroData {
                    
                case .isSunrise:
                    hourlyViewModels.append(
                        HourlyCellViewModel(time: DateConverter.createTimeString(from: item.time),
                                            image: UIImage(systemName: "sunrise.fill")?.withRenderingMode(.alwaysOriginal),
                                            chanceOfRain: "0 %",
                                            temp: "Sunrise")
                    )
                case .isSunset:
                    hourlyViewModels.append(
                        HourlyCellViewModel(time: DateConverter.createTimeString(from: item.time),
                                            image: UIImage(systemName: "sunset.fill")?.withRenderingMode(.alwaysOriginal),
                                            chanceOfRain: "0 %",
                                            temp: "Sunset")
                    )
                }
            }
            
            if let weatherData = item.weatherData {
                hourlyViewModels.append(
                    HourlyCellViewModel(time: weatherData.time == "Now" ? "Now" : DateConverter.createTimeString(from: item.time),
                                        image: item.weatherData?.condition.code.imageDay,
                                        chanceOfRain: "\(weatherData.chanceOfRain) %",
                                        temp: "\(Int(weatherData.temp))°")
                )
            }
        }
        completion(hourlyViewModels)
    }
    
    /// Creates daily cell view models
    private func createDailyCellViewModels(from weatherData: WeatherResponse, completion: ([DailyCellViewModel]) -> Void) {
        var dailyCellViewModels = [DailyCellViewModel]()
        
        let forecast = weatherData.forecast.forecastday
        
        for day in forecast {
            let cellViewModel = DailyCellViewModel(day: DateConverter.getDayFromDate(day.date),
                                                   image: day.day.condition.code.imageDay,
                                                   chanceOfRain: "\(day.day.dailyChanceOfRain) %",
                                                   minTemp: "\(Int(day.day.minTemp))°",
                                                   maxTemp: "\(Int(day.day.maxTemp))°")
            dailyCellViewModels.append(cellViewModel)
        }
        completion(dailyCellViewModels)
    }
}
