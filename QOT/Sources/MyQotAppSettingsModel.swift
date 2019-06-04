//
//  MyQotAppSettingsModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

struct MyQotAppSettingsModel {
   
    enum SettingsType: Int, CaseIterable {
        case general
        case custom
    }
    
    // MARK: - Properties
    
    let services: Services
    
    init(services: Services) {
        self.services = services
    }
    
    var generalSettingsCount: Int {
        return Setting.generalSettings.count
    }
    
    var customSettingsCount: Int {
        return Setting.customSettings.count
    }
    
    var sectionCount: Int {
        return Section.values.count
    }
    
    func headerTitleForItem(at section: Int) -> String {
        return headertitle(for: Section.values.item(at: section))
    }
    
    func settingItem(at indexPath: IndexPath) -> Setting {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            return Setting.generalSettings.item(at: indexPath.row)
        case .custom:
            return Setting.customSettings.item(at: indexPath.row)
        }
    }
    
    func subtitleForItem(at indexPath: IndexPath) -> String {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            return subtitle(for: Setting.generalSettings.item(at: indexPath.row))
        case .custom:
            return subtitle(for: Setting.customSettings.item(at: indexPath.row))
        }
    }
    
    func trackingKeyForItem(at indexPath: IndexPath) -> String {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            return trackingKey(for: Setting.generalSettings.item(at: indexPath.row))
        case .custom:
            return trackingKey(for: Setting.customSettings.item(at: indexPath.row))
        }
    }
    
    func titleForItem(at indexPath: IndexPath) -> String {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            return title(for: Setting.generalSettings.item(at: indexPath.row))
        case .custom:
            return title(for: Setting.customSettings.item(at: indexPath.row))
        }
    }
    
    func contentCollection(_ setting: Setting) -> ContentCollection? {
        return setting.contentCollection(for: services.contentService)
    }
    
    private func trackingKey(for item: Setting) -> String {
        switch item {
        case .permissions:
            return ContentService.AppSettings.Profile.permissions.rawValue
        case .notifications:
            return ContentService.AppSettings.Profile.notifications.rawValue
        case .calendars:
            return ContentService.AppSettings.Profile.syncedCalendars.rawValue
        case .sensors:
            return ContentService.AppSettings.Profile.activityTrackers.rawValue
        case .siriShortcuts:
            return ContentService.AppSettings.Profile.siriShortcuts.rawValue
        }
    }
    
    private func title(for item: Setting) -> String {
        switch item {
        case .permissions:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.permissions.predicate) ?? ""
        case .notifications:
             return services.contentService.localizedString(for: ContentService.AppSettings.Profile.notifications.predicate) ?? ""
        case .calendars:
          return services.contentService.localizedString(for: ContentService.AppSettings.Profile.syncedCalendars.predicate) ?? ""
        case .sensors:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.activityTrackers.predicate) ?? ""
        case .siriShortcuts:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.siriShortcuts.predicate) ?? ""
        }
    }
    
    private func subtitle(for item: Setting) -> String {
        switch item {
        case .permissions:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.appSettingsAllowQotToAccessYourDevice.predicate) ?? ""
        case .notifications:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.allowAlertsForSomeQOTFeatures.predicate) ?? ""
        case .calendars:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.syncYourPersonalCalendarWithQot.predicate) ?? ""
        case .sensors:
             return services.contentService.localizedString(for: ContentService.AppSettings.Profile.connectWearablesToQot.predicate) ?? ""
        case .siriShortcuts:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.recodYourVoiceAndCreateShortcuts.predicate) ?? ""
        }
    }
    
    private func headertitle(for item: Section) -> String {
        switch item {
        case .general:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.generalSettings.predicate) ?? ""
        case .custom:
            return services.contentService.localizedString(for: ContentService.AppSettings.Profile.customSettings.predicate) ?? ""
        }
    }
}

extension MyQotAppSettingsModel {
    
    enum Setting: Int {
        case permissions = 0
        case notifications
        case calendars
        case sensors
        case siriShortcuts
        
        static var generalSettings: [Setting] {
            return [.notifications, .permissions]
        }
        
        static var customSettings: [Setting] {
            return [.calendars, .sensors, .siriShortcuts]
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
    
    enum Section: Int {
        case general = 0
        case custom
        
        static var values: [Section] {
            return [.general, .custom]
        }
    }
}
