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

    static let shared = LocationManager()
    var didUpdateLocations: ((_ location: CLLocation) -> Void)?

    // MARK: - Init

    private override init() {}

    var locationServiceEnabled: Bool {
        if LocationManager.locationServicesEnabled() == true {
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

    var authorizationStatus: CLAuthorizationStatus {
        return LocationManager.authorizationStatus()
    }

    func startSignificantLocationMonitoring(didUpdateLocations: ((_ location: CLLocation) -> Void)?) {
        guard authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse else {
            return
        }

        self.didUpdateLocations = didUpdateLocations
        delegate = self
        startMonitoringSignificantLocationChanges()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else {
            return
        }

        didUpdateLocations?(lastLocation)
    }
}
