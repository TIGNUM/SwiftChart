//
//  LocationPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import CoreLocation

class LocationPermission: NSObject, PermissionInterface {
    private var locationPermissionCompletion: ((Bool) -> Void)?
    private let locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
    }

    func authorizationStatusDescription(completion: @escaping (String) -> Void) {
        completion(CLLocationManager.authorizationStatus().stringValue)
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        let status = CLLocationManager.authorizationStatus()
        guard status != .denied, status != .restricted else {
            completion(false)
            return
        }
        guard status != .authorizedAlways && status != .authorizedWhenInUse else {
            completion(true)
            return
        }

        locationPermissionCompletion = completion
        locationManager.requestAlwaysAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationPermission: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationPermissionCompletion?(status == .authorizedAlways || status == .authorizedWhenInUse)
        locationPermissionCompletion = nil
    }
}

// MARK: - CLAuthorizationStatus

private extension CLAuthorizationStatus {
    var stringValue: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorizedWhenInUse:
            return "authorizedWhenInUse"
        case .authorizedAlways:
            return "authorizedAlways"
        }
    }
}
