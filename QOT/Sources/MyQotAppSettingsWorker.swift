//
//  MyQotAppSettingsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotAppSettingsWorker {

    private let contentService: ContentService

    // MARK: - Init

    init(contentService: ContentService) {
        self.contentService = contentService
    }

    func settings() -> MyQotAppSettingsModel {
        return MyQotAppSettingsModel(contentService: contentService)
    }
}

extension MyQotAppSettingsWorker {

    var appSettingsText: String {
        return AppTextService.get(.my_qot_my_profile_section_app_settings_title)
    }

    var calendarAuthorizationStatus: EKAuthorizationStatus {
        return CalendarPermission().authorizationStatus
    }
}
