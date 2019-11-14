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
        return AppTextService.get(AppTextKey.coach_prepare_sync_calendar_section_header_title)
    }()

    lazy var viewTitle: String = {
        return AppTextService.get(AppTextKey.coach_prepare_sync_calendar_section_header_body)
    }()

    lazy var skipButton: String = {
        return AppTextService.get(AppTextKey.coach_prepare_sync_calendar_edit_button_skip_enable)
    }()

    lazy var saveButton: String = {
        return AppTextService.get(AppTextKey.coach_prepare_sync_calendar_edit_button_save)
    }()
}
