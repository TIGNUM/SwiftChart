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
    var currentLocalityName: String?

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

    func startSignificantLocationMonitoring(didUpdateLocations: ((_ location: CLLocation) -> Void)?) {
        guard LocationManager.authorizationStatus == .authorizedAlways
            || LocationManager.authorizationStatus == .authorizedWhenInUse
            || LocationManager.significantLocationChangeMonitoringAvailable() == true else { return }
        self.didUpdateLocations = didUpdateLocations
        delegate = self
        distanceFilter = kCLLocationAccuracyHundredMeters
        startMonitoringSignificantLocationChanges()
    }

    func startWeatherLocationMonitoring(didUpdateLocations: ((_ location: CLLocation) -> Void)?) {
        guard LocationManager.authorizationStatus == .authorizedAlways
            || LocationManager.authorizationStatus == .authorizedWhenInUse else { return }
        self.didUpdateLocations = didUpdateLocations
        delegate = self
        distanceFilter = kCLLocationAccuracyThreeKilometers
        startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: lastLocation.coordinate.latitude, longitude: lastLocation.coordinate.longitude)) { [weak self] placemark, error in
            guard let strongSelf = self else { return }

            guard let placemark = placemark, error == nil else {
                strongSelf.currentLocalityName = nil
                strongSelf.didUpdateLocations?(lastLocation)
                return
            }

            var displayName: String?

            if let currentPlacemark = placemark.first,
                let country = currentPlacemark.country {
                if let locality = currentPlacemark.locality {
                    displayName = "\(locality), \(country)"
                } else if let administrativeArea = currentPlacemark.administrativeArea {
                    displayName = "\(administrativeArea), \(country)"
                } else {
                    displayName = "\(country)"
                }
            }

            strongSelf.currentLocalityName = displayName
            strongSelf.didUpdateLocations?(lastLocation)
        }
    }
}
