//
//  CalendarPermission.swift
//  QOT
//
//  Created by Lee Arromba on 30/11/2017.
//  Copyright © 2017 Tignum. All rights reserved.
//

import Foundation
import EventKit

struct CalendarPermission: PermissionInterface {
    func authorizationStatusDescription(completion: @escaping (String) -> Void) {
        switch EKEventStore.authorizationStatus(for: .event) {
        case .notDetermined:
            completion("notDetermined")
        case .restricted:
            completion("restricted")
        case .denied:
            completion("denied")
        default:
            completion("authorized")
        }
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
    var stringValue: String {
        switch self {
        case .notDetermined:
            return "notDetermined"
        case .restricted:
            return "restricted"
        case .denied:
            return "denied"
        case .authorized:
            return "authorized"
        }
    }
}
