//
//  SyncedCalendarsModels.swift
//  QOT
//
//  Created by karmic on 17.08.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct SyncedCalendarsViewModel {
    let viewTitle: String
    let headerConfig = TitleTableHeaderView.Config(backgroundColor: .clear)
    let headerHeight: CGFloat = 60
    var sections: [Section: [Row]]

    mutating func updateSyncValue(_ enabled: Bool?, calendarId: String?) {
        guard let index = sections[.onDevice]?.firstIndex(where: { $0.identifier == calendarId }) else { return }
        let row = sections[.onDevice]?.at(index: index)
        sections[.onDevice]?.remove(at: index)
        sections[.onDevice]?.insert(SyncedCalendarsViewModel.Row(title: row?.title,
                                                                 identifier: row?.identifier,
                                                                 source: row?.source,
                                                                 syncEnabled: enabled,
                                                                 switchIsHidden: row?.switchIsHidden), at: index)
    }

    struct Row {
        let title: String?
        let identifier: String?
        let source: String?
        let syncEnabled: Bool?
        let switchIsHidden: Bool?
    }

    enum Section: Int {
        case onDevice = 0
        case notOnDevice

        var title: String {
            switch self {
            case .onDevice:
                return R.string.localized.settingsCalendarSectionOnThisDeviceHeader()
            case .notOnDevice:
                return R.string.localized.settingsCalendarSectionOnOtherDevicesHeader()
            }
        }
    }
}
