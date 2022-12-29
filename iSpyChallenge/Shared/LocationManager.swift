//
//  LocationManager.swift
//  iSpyChallenge
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate, ObservableObject {
    
    static let shared = LocationManager()
    // For testing and default value purposes
    static let mockedLocation =  CLLocation(latitude: 37.7904462, longitude: -122.4011537)
    
    private let locationManager = CLLocationManager()

    @Published var currentLocation: CLLocation?
    
    override init() {
        super.init()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
        requestLocation()
    }
    
    func startUpdatingLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func getDistance(from location: CLLocation) -> Double {
        return (currentLocation?.distance(from: location) ?? LocationManager.mockedLocation.distance(from: location)) / 1609.34 // miles
    }
    
    // MARK: - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {  // manager.location
            print("Current location: \(location.coordinate.latitude) \(location.coordinate.longitude)")
            self.currentLocation = location
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}
