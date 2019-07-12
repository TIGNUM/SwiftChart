//
//  ContentService+AppSettings.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

extension ContentService {

    struct AppSettings {
        enum Profile: String, CaseIterable, Predicatable {
            case appSettings = "app_settings_app_settings"
            case generalSettings = "app_settings_general_settings"
            case customSettings = "app_settings_custom_settings"
            case notifications = "app_settings_notifications"
            case allowAlertsForSomeQOTFeatures = "app_settings_allow_alerts_for_some_qot_features"
            case permissions = "app_settings_permissions"
            case appSettingsAllowQotToAccessYourDevice = "app_settings_allow_qot_to_access_your_device"
            case syncedCalendars = "app_settings_synced_calendars"
            case syncYourPersonalCalendarWithQot = "app_settings_sync_your_personal_calendar_with_qot"
            case activityTrackers = "app_settings_activity_trackers"
            case connectWearablesToQot = "app_settings_connect_wearables_to_qot"
            case siriShortcuts = "app_settings_siri_shortcuts"
            case recodYourVoiceAndCreateShortcuts = "app_settings_record_your_voice_and_create_shortcuts"

            var predicate: NSPredicate {
                return NSPredicate(dalSearchTag: rawValue)
            }
        }
    }
}
