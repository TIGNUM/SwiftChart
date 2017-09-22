//
//  CLLocationManager+Convenience.swift
//  QOT
//
//  Created by karmic on 25.07.17.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationManager {

    static var locationServiceEnabled: Bool {
        if CLLocationManager.locationServicesEnabled() == true {
            switch LocationManager.authorizationStatus {
            case .authorizedAlways,
                 .authorizedWhenInUse: return true
            case .denied,
                 .notDetermined,
                 .restricted: return false
            }
        }

        return false
    }

    static var authorizationStatus: CLAuthorizationStatus {
        return CLLocationManager.authorizationStatus()
    }
}
