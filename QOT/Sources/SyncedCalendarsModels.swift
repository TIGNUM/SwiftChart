//
//  SyncedCalendarsModels.swift
//  QOT
//
//  Created by karmic on 17.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct SyncedCalendarsViewModel {
    let viewTitle: String
    let viewSubtitle: String
    let headerHeight: CGFloat = 80
    var footerHeight: CGFloat
    var sections: [Section: [Row]]

    mutating func updateSyncValue(_ enabled: Bool?, calendarId: String?) {
        guard let index = sections[.onDevice]?.firstIndex(where: { $0.identifier == calendarId }) else { return }
        let row = sections[.onDevice]?.at(index: index)
        sections[.onDevice]?.remove(at: index)
        sections[.onDevice]?.insert(SyncedCalendarsViewModel.Row(title: row?.title,
                                                                 identifier: row?.identifier,
                                                                 source: row?.source,
                                                                 syncEnabled: enabled,
                                                                 isSubscribed: row?.isSubscribed,
                                                                 switchIsHidden: row?.switchIsHidden), at: index)
    }

    struct Row {
        let title: String?
        let identifier: String?
        let source: String?
        let syncEnabled: Bool?
        let isSubscribed: Bool?
        let switchIsHidden: Bool?
    }

    enum Section: Int {
        case onDevice = 0
        case notOnDevice

        var title: String {
            switch self {
            case .onDevice:
                return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_synced_calendars_view_this_device_title)
            case .notOnDevice:
                return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_synced_calendars_view_other_devices_title)
            }
        }
    }
}
