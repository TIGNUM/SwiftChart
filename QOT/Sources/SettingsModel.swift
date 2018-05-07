//
//  SettingsModel.swift
//  QOT
//
//  Created by Javier Sanz Rozalen on 26/04/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

struct SettingsModel {

    enum Setting: Int {
        case permissions = 0
        case notifications
        case calendars
        case sensors

        static var settingsValues: [Setting] {
            return [.permissions, .notifications, .calendars, .sensors]
        }

        var title: String {
            switch self {
            case .permissions: return R.string.localized.sidebarTitlePermission()
            case .notifications: return R.string.localized.settingsTitleNotifications()
            case .calendars: return R.string.localized.settingsGeneralCalendarTitle()
            case .sensors: return R.string.localized.sidebarTitleSensor()
            }
        }

        var primaryKey: Int {
            switch self {
            case .sensors: return 100935
            default: return 0
            }
        }

        func contentCollection(for service: ContentService) -> ContentCollection? {
            switch self {
            case .sensors: return service.contentCollection(id: primaryKey)
            default: return nil
            }
        }
    }

    // MARK: - Properties

    let services: Services

    init(services: Services) {
        self.services = services
    }

    var itemCount: Int {
        return Setting.settingsValues.count
    }

    func settingItem(at indexPath: IndexPath) -> Setting {
        return Setting.settingsValues.item(at: indexPath.row)
    }

    func contentCollection(_ setting: Setting) -> ContentCollection? {
        return setting.contentCollection(for: services.contentService)
    }
}
