//
//  ContentView.swift
//  LoacationButton
//
//  Created by Luka Vujnovac on 28.09.2021..
//

import CoreLocationUI
import MapKit
import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = ContentViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom){
            Map(coordinateRegion: $viewModel.region, showsUserLocation: true)
                .ignoresSafeArea()
                .tint(.pink)
            
            LocationButton(.currentLocation) { 
                viewModel.requestAllowOnceLocationPermission()
                    
            }
            .foregroundColor(.white)
            .cornerRadius(8)
            .labelStyle(.titleAndIcon)
            .symbolVariant(.fill)
            .padding(.bottom, 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

final class ContentViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 40, longitude: 120), span: MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100))

    let locationMenager = CLLocationManager()
    
    override init() {
        super.init()
        locationMenager.delegate = self
    }
    
    func requestAllowOnceLocationPermission() {
        locationMenager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else {return}
        
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(center: latestLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
