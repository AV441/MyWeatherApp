//
//  Networking.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit
import CoreLocation

extension ViewController {
    func requestWeatherData() {
        
        guard let currentLocation = self.currentLocation else { return }
        
        let lat = currentLocation.coordinate.latitude
        let lon = currentLocation.coordinate.longitude
        
        let url = URL(string: "http://api.weatherapi.com/v1/forecast.json?key=fabdc37da9544f0cad993304222405&q=\(lat),\(lon)&days=3&lang=ru")!
        
        URLSession.shared.dataTask(with: url) { data, response, error  in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode == 200 {
                guard let data = data else { return }
                DispatchQueue.main.async {
                    do {
                        let fetchedWeatherData = try JSONDecoder().decode(WeatherResponse.self, from: data)
                        let results = fetchedWeatherData
                        
                        //TODO: change Background
                        if results.current.isDay == 1 {
                            let image = UIImage(named: "backgroundDay")
                            self.setBackground(with: image)
                        } else {
                            let image = UIImage(named: "backgroundNight")
                            self.setBackground(with: image)
                        }
                        
                        //TODO: fill Current Items
                        var currentItems = [Item]()
                        
                        let currentWeather = CurrentWeather(locationName: self.locationName,
                                                            weather: results.current)
                        currentItems.append(Item.current(currentWeather))
                        
                        //TODO: fill Hourly Items
                        var hourlyItems = [Item.hourly(HourlyWeather(weatherData: HourlyForecast(time: "Сейчас",
                                                                                                 temp: results.current.temp,
                                                                                                 isDay: results.current.isDay,
                                                                                                 chanceOfRain: 0,
                                                                                                 condition: results.current.condition),
                                                                     astroData: nil,
                                                                     astroKind: nil))]
                        
                        let sunriseTimeString = results.forecast.forecastday[0].astro.sunrise
                        let sunsetTimeString = results.forecast.forecastday[0].astro.sunset
                        
                        guard let sunriseTime = DateConverter.convertAstroTime(from: sunriseTimeString)?.0,
                              let sunsetTime = DateConverter.convertAstroTime(from: sunsetTimeString)?.0,
                              let currentTime = DateConverter.convertCurrentTime() else { return }
                        
                        let hourlyWeatherArray = results.forecast.forecastday[0].hour + results.forecast.forecastday[1].hour
                        
                        for i in 0...(hourlyWeatherArray.count - 2) {
                            guard let forecastTimeWithDate = DateConverter.convertForecastTimeWithDate(from: hourlyWeatherArray[i].time),
                                  let forecastTimeWithoutDate1 = DateConverter.convertForecastTimeWithoutDate(from: hourlyWeatherArray[i].time),
                                  let forecastTimeWithoutDate2 = DateConverter.convertForecastTimeWithoutDate(from: hourlyWeatherArray[i+1].time) else { return }
                            if hourlyItems.count != 27 {
                                if forecastTimeWithDate >= currentTime {
                                    if sunriseTime >= forecastTimeWithoutDate1, sunriseTime <= forecastTimeWithoutDate2 {
                                        
                                        hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: nil, astroKind: nil)))
                                        hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: results.forecast.forecastday[0].astro, astroKind: HourlyWeather.AstroKind.isSunrise)))
                                        
                                    } else if sunsetTime >= forecastTimeWithoutDate1, sunsetTime <= forecastTimeWithoutDate2  {
                                        
                                        hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: nil, astroKind: nil)))
                                        hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: results.forecast.forecastday[0].astro, astroKind: HourlyWeather.AstroKind.isSunset)))
                                        
                                    } else {
                                        
                                        hourlyItems.append(Item.hourly(HourlyWeather(weatherData: hourlyWeatherArray[i], astroData: nil, astroKind: nil)))
                                    }
                                }
                            }
                        }
                        
                        //TODO: fill Daily Items
                        var dailyItems = [Item]()
                        results.forecast.forecastday.forEach { element in
                            dailyItems.append(Item.daily(element))
                        }
                        
                        //TODO: fill Sections
                        let sections: [Section: [Item]] = [
                            Section.current: currentItems,
                            Section.hourly: hourlyItems,
                            Section.daily: dailyItems
                        ]
                        
                        //TODO: apply Snapshot
                        self.applySnapshot(with: sections)
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            } else {
                print("HTTPURLResponse code: \(response.statusCode)")
            }
        }.resume()
    }
}
