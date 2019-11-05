//
//  CalendarPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

class CalendarPermission: PermissionInterface {
    func authorizationStatusDescription() -> PermissionsManager.AuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event).authorizationStatus
    }

    var authorizationStatus: EKAuthorizationStatus {
        return EKEventStore.authorizationStatus(for: .event)
    }

    func askPermission(completion: @escaping (Bool) -> Void) {
        EKEventStore.shared.requestAccess(to: .event) { (granted: Bool, _: Error?) in
            if granted {
                EKEventStore.shared = EKEventStore()
            }
            completion(granted)
        }
    }
}

// MARK: - EKAuthorizationStatus
private extension EKAuthorizationStatus {
    var authorizationStatus: PermissionsManager.AuthorizationStatus {
        switch self {
        case .notDetermined:
            return PermissionsManager.AuthorizationStatus.notDetermined
        case .denied:
            return PermissionsManager.AuthorizationStatus.denied
        case .restricted:
            return PermissionsManager.AuthorizationStatus.restricted
        case .authorized:
            return PermissionsManager.AuthorizationStatus.granted
        }
    }
}
