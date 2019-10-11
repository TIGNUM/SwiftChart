//
//  SyncedCalendarsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class SyncedCalendarsWorker {
    lazy var viewSubtitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_synced_calendar_view_title)
    }()

    lazy var viewTitle: String = {
        return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_synced_calendar_view_subtitle)
    }()

    lazy var skipButton: String = {
        return AppTextService.get(AppTextKey.my_qot_calendars_view_button_skip)
    }()

    lazy var saveButton: String = {
        return AppTextService.get(AppTextKey.my_qot_calendars_view_button_save)
    }()
}
