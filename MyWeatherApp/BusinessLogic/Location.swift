//
//  Location.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import UIKit
import CoreLocation

extension ViewController {
    
    func getLocation() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        
        guard let location = locationManager.location else { return }
        currentLocation = location
        geoCoder.reverseGeocodeLocation(location) { placemark, error in
            guard let placemarks = placemark else { return }
            guard let name = placemarks[0].locality else { return }
            self.locationName = name
            self.requestWeatherData()
        }
    }
}
