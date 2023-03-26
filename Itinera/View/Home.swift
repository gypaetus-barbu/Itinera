//
//  Home.swift
//  Itinera
//
//  Created by louis on 21/03/2023.
//

import SwiftUI
import MapKit

struct MapsView: View {
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
    @State private var locationManger = LocationManager()

    var body: some View {
        Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(.follow) )
                .ignoresSafeArea()
    }
}


struct Home: View {

    // access to the user location
    @StateObject var locationManger: LocationManager = .init()

    // button to recenter the map on the user location
    @State private var recenter = false

    // region
    @State private var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))



    var body: some View {
        ZStack {
            Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: .constant(recenter == true ? .follow : .none) )
                .ignoresSafeArea()
                .overlay(alignment: .topTrailing) {
                    Button(action: {
                        updateLocation(lat: locationManger.getLatitude(), long: locationManger.getLongitude())
                    }, label: {
                        Image(systemName: "location.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 10,
                                    style: .continuous)
                                    .fill(.ultraThickMaterial)
                            }
                    }).padding()
                }
            .bottomSheet(presentationDetents: [.medium, .large, .height(70)],
            isPresented: .constant(true),
            sheetCornerRadius: 20) {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        TextField("Search", text: $locationManger.searchText)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background {
                                RoundedRectangle (cornerRadius: 10,
                                        style: .continuous)
                                        .fill(.ultraThickMaterial)}
                        MapsList()
                    }
                    .padding()
                    .padding(.top)
                }
            } onDismiss: {}
        }
    }


    @ViewBuilder
    func MapsList() -> some View {
        VStack (spacing: 25) {
            if !locationManger.fetchPlaces.isEmpty {
                HStack (spacing: 12) {
                    ForEach(locationManger.fetchPlaces, id: \.self) { place in
                        Button(action: {
                            locationManger.selectPlace(place)
                            updateLocation(lat: place.location?.coordinate.latitude ?? 0, long: place.location?.coordinate.longitude ?? 0)
                        }) {
                            Text(place.name ?? "")
                                .font(.title3)
                                .fontWeight(.semibold)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
            ForEach (maps) { Map_search in
                HStack (spacing: 12) {
                    Button(action: {
                        updateLocation(lat: Map_search.latitude, long: Map_search.longitude)
                    }, label: {
                        Map_search.addressType.icon
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 20, height: 20)
                        Text("\(Map_search.name)")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                        Spacer()
                        Text("\(distance(lat1: locationManger.getLatitude(), lon1: locationManger.getLongitude(), lat2: Map_search.latitude, lon2: Map_search.longitude), specifier: "%.2f") km")
                                .font(.caption)
                                .foregroundColor(.secondary)
                    })
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }

    func getIndex(map: Map_search) -> Int {
        return maps.firstIndex { C_map in
            C_map.id == map.id
        } ?? 0
    }

    func updateLocation(lat: Double, long: Double) {
        region.center = CLLocationCoordinate2D(latitude: lat, longitude: long)
    }

    // make a function to calculate distance between two points
    func distance(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> Double {
        let theta = lon1 - lon2
        var dist = sin(deg2rad(deg: lat1)) * sin(deg2rad(deg: lat2)) + cos(deg2rad(deg: lat1)) * cos(deg2rad(deg: lat2)) * cos(deg2rad(deg: theta))
        dist = acos(dist)
        dist = rad2deg(rad: dist)
        dist = dist * 60 * 1.1515
        return dist
    }

    // convert degree to radian
    func deg2rad(deg: Double) -> Double {
        deg * Double.pi / 180
    }

    // convert radian to degree
    func rad2deg(rad: Double) -> Double {
        rad * 180 / Double.pi
    }

    // calculate distance between my localisation and one point
    func distanceFromMe(lat: Double, long: Double) -> Double {
        // get my localisation
        let myLat: Double = LocationManager.getLatitude(locationManger)()
        let myLong: Double = LocationManager.getLongitude(locationManger)()

        return distance(lat1: myLat, lon1: myLong, lat2: lat, lon2: long)
    }

}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
