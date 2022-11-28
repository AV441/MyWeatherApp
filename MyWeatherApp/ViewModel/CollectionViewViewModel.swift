//
//  WeatherViewModel.swift
//  MyWeatherApp
//
//  Created by Андрей on 15.11.2022.
//

import Foundation

final class CollectionViewViewModel: NSObject {
    private let locationService = LocationService()
    private let weatherService = WeatherService()
    
    public var updateCollectionView: () -> Void = {}
    public var updateTableView: () -> Void = {}
    public var updateBackground: ((Bool) -> Void)?
        
    public var locations = [SearchResponse]()
    
    private var currentItems = [CurrentItem]()
    private var hourlyItems = [HourlyItem]()
    private var dailyItems = [DailyItem]()
    
    public var weatherData: WeatherResponse? {
        willSet(weatherData) {
            createWeatherItems(from: weatherData)
        }
    }
    
    override init() {
        super.init()
        getWeatherDataForCurrentLocation()
    }
    
    /// Returns number of items for the given section index
    public func numberOfItems(inSection index: Int) -> Int {
        switch Section.allCases[index] {
        case .current:
            return currentItems.count
        case .hourly:
            return hourlyItems.count
        case .daily:
            return dailyItems.count
        }
    }
    
    /// Returns cell viewModel for the given indexPath
    public func cellViewModel(for indexPath: IndexPath) -> AnyObject {
        let section = Section.allCases[indexPath.section]
        
        switch section {
        case .current:
            let item = currentItems[indexPath.item]
            return CurrentCellViewModel(item)
        case .hourly:
            let item = hourlyItems[indexPath.item]
            return HourlyCellViewModel(item)
        case .daily:
            let item = dailyItems[indexPath.item]
            return DailyCellViewModel(item)
        }
    }
    
    /// Requests weather data for the current location and updates collection view
    public func getWeatherDataForCurrentLocation() {
        locationService.updateLocation { [weak self] result in
            switch result {
            case .success(let coordinates):
                self?.weatherService.requestWeatherData(for: coordinates) { [weak self] result in
                    switch result {
                    case .success(let weatherData):
                        self?.weatherData = weatherData
                        self?.updateCollectionView()
                        
                        let isDay = weatherData.current.isDay
                        self?.updateBackground?(isDay == 1 ? true : false)
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    /// Requests weather data for the given location name and updates collection view
    public func getWeatherData(for locationName: String) {
        weatherService.requestWeatherData(for: locationName) { [weak self] result in
            switch result {
            case .success(let weatherData):
                UserDefaults.standard.set(locationName, forKey: "lastLocation")
                self?.weatherData = weatherData
                self?.updateCollectionView()
                
                let isDay = weatherData.current.isDay
                self?.updateBackground?(isDay == 1 ? true : false)
                
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
    
    /// Creates items for collection view cells viewModels
    func createWeatherItems(from weatherData: WeatherResponse?) {
        guard let weatherData = weatherData else {
            return
        }
        
        // Current items
        var currentItems = [CurrentItem]()
        let currentItem = CurrentItem(location: weatherData.location,
                                      current: weatherData.current)
        currentItems.append(currentItem)
        self.currentItems = currentItems

        // Daily items
        var dailyItems = [DailyItem]()
        weatherData.forecast.forecastday.forEach {
            let dailyItem = DailyItem(forecast: $0)
            dailyItems.append(dailyItem)
        }
        self.dailyItems = dailyItems
   
        // Hourly items
        var hourlyItems = [HourlyItem]()
        let currentTime = DateConverter.convertCurrentTime()
        
        let firstItem = HourlyItem(time: .now,
                                   astroData: nil,
                                   weatherData: HourlyForecast(time: "Now",
                                                               temp: weatherData.current.temp,
                                                               isDay: weatherData.current.isDay,
                                                               chanceOfRain: 0,
                                                               condition: weatherData.current.condition))
        
        for i in 0...1 {
            let sunriseTimeString = weatherData.forecast.forecastday[i].astro.sunrise
            let sunsetTimeString = weatherData.forecast.forecastday[i].astro.sunset
            let forecastDateString = weatherData.forecast.forecastday[i].date
            
            
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
            
            let hourlyWeather = weatherData.forecast.forecastday[i].hour
            
            hourlyWeather.forEach {
                let time = DateConverter.convertForecastTime(from: $0.time)
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

        self.hourlyItems = hourlyItems
    }
}
