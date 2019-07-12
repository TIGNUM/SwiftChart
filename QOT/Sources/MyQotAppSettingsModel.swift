//
//  MyQotAppSettingsModel.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

struct MyQotAppSettingsModel {

    enum SettingsType: Int, CaseIterable {
        case general
        case custom
    }

    // MARK: - Properties

    let contentService: qot_dal.ContentService

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
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

    func headerTitleForItem(at section: Int, completion: @escaping(String) -> Void) {
        headertitle(for: Section.values.item(at: section)) { (text) in
            completion(text)
        }
    }

    func heightForHeader(in section: Int) -> CGFloat {
        let type = SettingsType.allCases[section]
        switch type {
        case .general, .custom:
            return CGFloat(68)
        }
    }

    func heightForFooter(in section: Int) -> CGFloat {
        let type = SettingsType.allCases[section]
        switch type {
        case .general:
            return CGFloat(0.1)
        case .custom:
            return CGFloat(80)
        }
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

    func subtitleForItem(at indexPath: IndexPath, completion: @escaping(String) -> Void) {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            subtitle(for: Setting.generalSettings.item(at: indexPath.row)) { (text) in
                completion(text)
            }
        case .custom:
            subtitle(for: Setting.customSettings.item(at: indexPath.row)) { (text) in
                completion(text)
            }
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

    func titleForItem(at indexPath: IndexPath, completion: @escaping(String) -> Void) {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            title(for: Setting.generalSettings.item(at: indexPath.row)) { (text) in
                completion(text)
            }
        case .custom:
            title(for: Setting.customSettings.item(at: indexPath.row)) { (text) in
                completion(text)
            }
        }
    }

    func contentCollection(_ setting: Setting, completion: @escaping(QDMContentCollection?) -> Void) {
        setting.contentCollection(for: contentService) { (contentCollection) in
            completion(contentCollection)
        }
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

    private func title(for item: Setting, completion: @escaping(String) -> Void) {
        switch item {
        case .permissions:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.permissions.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .notifications:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.notifications.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .calendars:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.syncedCalendars.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .sensors:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.activityTrackers.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .siriShortcuts:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.siriShortcuts.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        }
    }

    private func subtitle(for item: Setting, completion: @escaping(String) -> Void) {
        switch item {
        case .permissions:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.appSettingsAllowQotToAccessYourDevice.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .notifications:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.allowAlertsForSomeQOTFeatures.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .calendars:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.syncYourPersonalCalendarWithQot.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .sensors:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.connectWearablesToQot.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .siriShortcuts:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.recodYourVoiceAndCreateShortcuts.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        }
    }

    private func headertitle(for item: Section, completion: @escaping(String) -> Void) {
        switch item {
        case .general:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.generalSettings.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .custom:
            contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.customSettings.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
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

        func contentCollection(for service: qot_dal.ContentService, completion: @escaping(QDMContentCollection?) -> Void) {
            switch self {
            case .sensors:
                service.getContentCollectionById(primaryKey) { (collection) in
                    completion(collection)
                }
            default:
                completion(nil)
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
