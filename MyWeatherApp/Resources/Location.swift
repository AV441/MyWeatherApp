//
//  Location.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import Foundation
import CoreLocation

final class LocationManager: NSObject {
    
    static let shared = LocationManager()
    
    private let geoCoder = CLGeocoder()
    private let manager = CLLocationManager()
    
    private override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
        }
    }
    
    public func getLocation() {
        manager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        
        guard let location = locations.last else { return }
        
        geoCoder.reverseGeocodeLocation(location) { placemark, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            
            guard let placemarks = placemark,
                  let name = placemarks[0].locality else {
                return
            }
            
            NetworkManager.shared.requestWeatherData(for: location.coordinate) { response in
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "location"), object: (response, name))
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error.localizedDescription)")
    }
}
