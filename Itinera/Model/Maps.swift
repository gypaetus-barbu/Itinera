//
// Created by louis on 22/03/2023.
//

import SwiftUI
// maps destination search bar

// type of address
enum AddressType {
    case home
    case work
    case shopping
    case other
}

struct Map_search: Identifiable {
    var id = UUID().uuidString
    var name: String
    var latitude: Double
    var longitude: Double
    var addressType: AddressType = .other
}

// generate icons for each address type
extension AddressType {
    var icon: Image {
        switch self {
        case .home:
            return Image(systemName: "house")
        case .work:
            return Image(systemName: "briefcase")
        case .shopping:
            return Image(systemName: "cart")
        case .other:
            return Image(systemName: "mappin.and.ellipse")
        }
    }
}

var maps: [Map_search] = [
    Map_search(name: "London", latitude: 51.507222, longitude: -0.1275, addressType: .home),
    Map_search(name: "Paris", latitude: 48.8566, longitude: 2.3522, addressType: .work),
    Map_search(name: "New York", latitude: 40.7128, longitude: -74.0060, addressType: .shopping),
    Map_search(name: "Tokyo", latitude: 35.6895, longitude: 139.6917, addressType: .other),
    Map_search(name: "Sydney", latitude: -33.8688, longitude: 151.2093, addressType: .other),
    Map_search(name: "Hong Kong", latitude: 22.3964, longitude: 114.1095, addressType: .other),
    Map_search(name: "Singapore", latitude: 1.3521, longitude: 103.8198, addressType: .other),
    Map_search(name: "Dubai", latitude: 25.2048, longitude: 55.2708, addressType: .shopping),
    Map_search(name: "Rome", latitude: 41.9028, longitude: 12.4964, addressType: .shopping),
    Map_search(name: "Barcelona", latitude: 41.3851, longitude: 2.1734, addressType: .shopping),
    Map_search(name: "Madrid", latitude: 40.4168, longitude: -3.7038, addressType: .shopping),
    Map_search(name: "Berlin", latitude: 52.5200, longitude: 13.4050, addressType: .shopping),
    Map_search(name: "Moscow", latitude: 55.7558, longitude: 37.6173, addressType: .shopping),
    Map_search(name: "Istanbul", latitude: 41.0082, longitude: 28.9784, addressType: .shopping),
    Map_search(name: "Cairo", latitude: 30.0444, longitude: 31.2357, addressType: .shopping),
    Map_search(name: "Beijing", latitude: 39.9042, longitude: 116.4074, addressType: .shopping),
    Map_search(name: "Seoul", latitude: 37.5665, longitude: 126.9780, addressType: .shopping),
    Map_search(name: "Shanghai", latitude: 31.2304, longitude: 121.4737, addressType: .shopping),
    Map_search(name: "Lagos", latitude: 6.5244, longitude: 3.3792, addressType: .shopping),
]