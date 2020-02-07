//
//  DailyBriefInteractor+BucketValidation.swift
//  QOT
//
//  Created by Sanggeon Park on 05.02.20.
//  Copyright © 2020 Tignum. All rights reserved.
//

import Foundation
import qot_dal

public enum FromTignumTags: String {
    case from_tignum_none
    case from_tignum_calendar_permission
    case from_tignum_connect_wearable
    case from_tignum_notification_permission
    case from_tignum_siri_shortcut
    case from_tignum_location_permission
    case from_tignum_create_tobevision
    case from_tignum_daily_check_in
}

extension DailyBriefInteractor {
    func isValidFromTignumBucket(_ bucket: QDMDailyBriefBucket) -> Bool {
        guard bucket.bucketName == .FROM_TIGNUM else { return false }
        guard let rawTag = bucket.contentCollections?.first?.searchTags.first,
            let tag = FromTignumTags(rawValue: rawTag.lowercased()) else {
                return true
        }

        switch tag {
        case .from_tignum_calendar_permission:
            switch AppCoordinator.permissionsManager?.currentStatusFor(for: .calendar) {
            case .granted, .restricted: return false
            default: break
            }
        case .from_tignum_connect_wearable:
            return !hasConnectedWearable
        case .from_tignum_notification_permission:
            switch AppCoordinator.permissionsManager?.currentStatusFor(for: .notifications) {
            case .granted, .restricted: return false
            default: break
            }
        case .from_tignum_siri_shortcut:
            return !hasSiriShortcuts
        case .from_tignum_location_permission:
            switch AppCoordinator.permissionsManager?.currentStatusFor(for: .location) {
            case .granted, .grantedWhileInForeground: return false
            default: break
            }
        case .from_tignum_create_tobevision:
            return !hasToBeVision
        case .from_tignum_daily_check_in:
            return !didDailyCheckIn
        default:
            return true
        }

        return true
    }
}
