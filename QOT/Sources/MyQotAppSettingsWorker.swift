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

    private let contentService: qot_dal.ContentService

    // MARK: - Init

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    func settings() -> MyQotAppSettingsModel {
        return MyQotAppSettingsModel(contentService: contentService)
    }
}

extension MyQotAppSettingsWorker {

    var appSettingsText: String {
        return ScreenTitleService.main.localizedString(for: .MyQotProfileAppSettings)
    }

    var calendarAuthorizationStatus: EKAuthorizationStatus {
        return CalendarPermission().authorizationStatus
    }
}
