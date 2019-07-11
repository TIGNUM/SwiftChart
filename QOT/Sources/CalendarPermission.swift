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
        completion(EKEventStore.authorizationStatus(for: .event).stringValue)
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
