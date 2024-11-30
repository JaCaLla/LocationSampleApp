//
//  ContentView.swift
//  LocationSampleApp
//
//  Created by Javier Calatrava on 30/11/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var locationManager = LocationManager.shared
    
    var body: some View {
        VStack(spacing: 20) {
            if let location = locationManager.currentLocation {
                Text("Latitude: \(location.latitude)")
                Text("Longitude: \(location.longitude)")
            } else {
                Text("Location not available")
            }
            
            if let address = locationManager.currentAddress {
                Text("Name: \(address.name ?? "Unknown")")
                Text("Town: \(address.locality ?? "Unknown")")
                Text("Country: \(address.country ?? "Unknown")")
            } else {
                Text("Address not available")
            }
            
            Button(action: {
                locationManager.requestLocation()
            }) {
                Text("Request Location")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .onAppear {
            locationManager.checkAuthorization()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

