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

    func authorizationStatusDescription() -> PermissionsManager.AuthorizationStatus {
        return CLLocationManager.authorizationStatus().authorizationStatus
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
        locationManager.requestWhenInUseAuthorization()
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationPermission: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        DispatchQueue.main.async {
            self.locationPermissionCompletion?(status == .authorizedAlways || status == .authorizedWhenInUse)
            self.locationPermissionCompletion = nil
        }
    }
}

// MARK: - CLAuthorizationStatus

private extension CLAuthorizationStatus {
    var authorizationStatus: PermissionsManager.AuthorizationStatus {
        switch self {
        case .denied:
            return PermissionsManager.AuthorizationStatus.denied
        case .restricted:
            return PermissionsManager.AuthorizationStatus.restricted
        case .authorizedWhenInUse:
            return PermissionsManager.AuthorizationStatus.grantedWhileInForeground
        case .authorizedAlways:
            return PermissionsManager.AuthorizationStatus.granted
        default:
            return PermissionsManager.AuthorizationStatus.notDetermined
        }
    }
}
