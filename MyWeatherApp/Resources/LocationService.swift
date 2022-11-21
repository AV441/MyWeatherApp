//
//  Location.swift
//  MyWeatherApp
//
//  Created by Андрей on 03.06.2022.
//

import Foundation
import CoreLocation
    
typealias LocationUpdateResult = Result<Coordinates, Error>

final class LocationService: NSObject {
    
    private var completion: ((LocationUpdateResult)-> Void)?
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func updateLocation(completion: @escaping (LocationUpdateResult) -> Void) {
        self.completion = completion
        locationManager.startUpdatingLocation()
    }
    
}

extension LocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            let coordinates = Coordinates(of: location)
            completion?(.success(coordinates))
        }
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        completion?(.failure(error))
    }
    
}

private extension Coordinates {
    
    init(of location: CLLocation) {
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
    }
    
}
