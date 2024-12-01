//
//  LocationManager.swift
//  LocationSampleApp
//
//  Created by Javier Calatrava on 30/11/24.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
   
    @MainActor
    static let shared = LocationManager()
    
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
    
    @Published var currentLocation: CLLocationCoordinate2D?
    @Published var currentAddress: CLPlacemark?
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
        
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func checkAuthorization() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted, .denied:
            print("Location access denied")
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.requestLocation()
        @unknown default:
            break
        }
    }
    
    // MARK :- CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkAuthorization()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            self.currentLocation = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                                          longitude: location.coordinate.longitude)
            reverseGeocode(location: location)
        }
    }
    
    private func reverseGeocode(location: CLLocation) {
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first, error == nil {
                self?.currentAddress = CLPlacemark(placemark: placemark)
            } else {
                print("Error during reverse geocoding: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }
}

