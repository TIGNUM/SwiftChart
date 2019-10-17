//
//  CLLocationManager+Convenience.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import CoreLocation

final class LocationManager: CLLocationManager {

    // MARK: - Properties

    var didUpdateLocations: ((_ location: CLLocation) -> Void)?

    // MARK: - Init

    override init() {
        super.init()

        pausesLocationUpdatesAutomatically = true
    }

    class var locationServiceEnabled: Bool {
        if locationServicesEnabled() == true {
            switch authorizationStatus {
            case .authorizedAlways,
                 .authorizedWhenInUse: return true
            case .denied,
                 .notDetermined,
                 .restricted: return false
            }
        }

        return false
    }

    class var authorizationStatus: CLAuthorizationStatus {
        return authorizationStatus()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        didUpdateLocations?(lastLocation)
    }
}
