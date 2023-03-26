//
// Created by louis on 23/03/2023.
//

import SwiftUI
import CoreLocation
import MapKit
import Combine

class LocationManager: NSObject, ObservableObject, MKMapViewDelegate, CLLocationManagerDelegate {

    @Published var mapView: MKMapView = .init()
    @Published var manager: CLLocationManager = .init()

    @Published var searchText: String = ""

    var cancellable: AnyCancellable?

    @Published var fetchPlaces: [CLPlacemark] = []

    @Published var selectedPlace: CLPlacemark?
    
    override init() {
        super.init()
        manager.delegate = self
        mapView.delegate = self

        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

        cancellable = $searchText
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] query in
                self?.fetchPlaces(for: query)
            }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocation location: [CLLocation]) {
        guard let _ = location.first else { return }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            case .authorizedAlways:
                manager.requestLocation()
            case .authorizedWhenInUse:
                manager.startUpdatingLocation()
            case .denied, .restricted:
                handleLocationError()
            case .notDetermined:
                manager.requestWhenInUseAuthorization()
            default: ()
        }
    }

    func handleLocationError(){
        print("Location access denied")
    }

    func fetchPlaces(for query: String) {
        selectedPlace = nil
        Task {
            do {
                let request = MKLocalSearch.Request()
                request.naturalLanguageQuery = query.lowercased()
                request.region = await mapView.region

                let response = try await MKLocalSearch(request: request).start()

                await MainActor.run(body: {
                    self.fetchPlaces = response.mapItems.compactMap({ item -> CLPlacemark? in
                        return item.placemark
                    })
                })
            }
            catch {

            }

        }

    }
    
    func selectPlace(_ placemark: CLPlacemark) {
        selectedPlace = placemark
        guard let location = placemark.location else { return }
        let coordinate = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        mapView.setCenter(coordinate, animated: true)
    }


    // get longitude and latitude of the user
    func getLongitude() -> Double {
        return manager.location?.coordinate.longitude ?? 0
    }

    func getLatitude() -> Double {
        return manager.location?.coordinate.latitude ?? 0
    }


}

