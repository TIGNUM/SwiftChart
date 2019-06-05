//
//  MyQotSyncedCalendarsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 15.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSyncedCalendarsWorker {

    private let viewModel: SettingsCalendarListViewModel
    private let services: Services

    init(services: Services, viewModel: SettingsCalendarListViewModel) {
        self.viewModel = viewModel
        self.services = services
    }

    var viewModelObj: SettingsCalendarListViewModel {
        return viewModel
    }

    var headerTitle: String {
        return services.contentService.localizedString(for: ContentService.SyncedCalendars.syncedCalendars.predicate) ?? ""
    }
}
