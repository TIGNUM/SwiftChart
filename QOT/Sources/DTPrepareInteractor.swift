//
//  DTPrepareInteractor.swift
//  QOT
//
//  Created by karmic on 13.09.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit
import qot_dal

final class DTPrepareInteractor: DTInteractor {}

// MARK: - DTPrepareInteractorInterface
extension DTPrepareInteractor: DTPrepareInteractorInterface {
    func getCalendarPermissionType() -> AskPermission.Kind? {
        let authStatus = EKEventStore.authorizationStatus(for: .event)
        switch authStatus {
        case .denied: return .calendarOpenSettings
        case .notDetermined: return .calendar
        default: return nil
        }
    }

    func setUserCalendarEvent(event: QDMUserCalendarEvent) {

    }
}
