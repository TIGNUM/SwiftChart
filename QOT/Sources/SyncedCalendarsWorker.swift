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
        return AppTextService.get(.my_qot_my_profile_app_settings_synced_calendars_section_header_subtitle)
    }()

    lazy var viewTitle: String = {
        return AppTextService.get(.coach_prepare_sync_calendar_section_header_title)
    }()

    lazy var skipButton: String = {
        return AppTextService.get(.coach_prepare_sync_calendar_edit_button_skip_enable)
    }()

    lazy var saveButton: String = {
        return AppTextService.get(.coach_prepare_sync_calendar_edit_button_save)
    }()
}
