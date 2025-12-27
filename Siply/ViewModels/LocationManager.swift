//
//  LocationManager.swift
//  Siply
//
//  Created on October 4, 2025.
//

import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    @Published var location: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var currentLocationName: String = ""
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func getCurrentLocation() {
        locationManager.requestLocation()
    }
    
    func getLocationName(for coordinate: CLLocationCoordinate2D, completion: @escaping (String) -> Void) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion("Unknown Location")
                return
            }
            
            if let placemark = placemarks?.first {
                let name = self.formatPlacemark(placemark)
                DispatchQueue.main.async {
                    completion(name)
                }
            } else {
                completion("Unknown Location")
            }
        }
    }
    
    private func formatPlacemark(_ placemark: CLPlacemark) -> String {
        var components: [String] = []
        
        if let name = placemark.name {
            components.append(name)
        }
        
        if let locality = placemark.locality {
            components.append(locality)
        }
        
        return components.joined(separator: ", ")
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        
        // Get location name
        getLocationName(for: location.coordinate) { name in
            self.currentLocationName = name
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            startUpdatingLocation()
        }
    }
}





