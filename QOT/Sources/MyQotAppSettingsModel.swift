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

    func headerTitleForItem(at section: Int) -> String {
        guard let itemSection = Section.values.at(index: section) else { return "UNKNOWN_SECTION_HEADER" }
        return headertitle(for: itemSection)
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
            return Setting.generalSettings.at(index: indexPath.row) ?? .permissions
        case .custom:
            return Setting.customSettings.at(index: indexPath.row) ?? .calendars
        }
    }

    func subtitleForItem(at indexPath: IndexPath) -> String {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            return subtitle(for: Setting.generalSettings.at(index: indexPath.row) ?? .notifications)
        case .custom:
            return subtitle(for: Setting.customSettings.at(index: indexPath.row) ?? .calendars)
        }
    }

    func titleForItem(at indexPath: IndexPath) -> String {
        let type = SettingsType.allCases[indexPath.section]
        switch type {
        case .general:
            return title(for: Setting.generalSettings.at(index: indexPath.row) ?? .notifications)
        case .custom:
            return title(for: Setting.customSettings.at(index: indexPath.row) ?? .calendars)
        }
    }

    func contentCollection(_ setting: Setting, completion: @escaping(QDMContentCollection?) -> Void) {
        setting.contentCollection(for: contentService) { (contentCollection) in
            completion(contentCollection)
        }
    }

    private func title(for item: Setting) -> String {
        switch item {
        case .permissions:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_permission)
        case .notifications:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_notification)
        case .calendars:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_sync_calendar)
        case .sensors:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_activity_trackers)
        case .siriShortcuts:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_siri)
        }
    }

    private func subtitle(for item: Setting) -> String {
        switch item {
        case .permissions:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_subtitle_permission)
        case .notifications:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_subtitle_notification)
        case .calendars:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_subtitle_sync_calendar)
        case .sensors:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_subtitle_activity_trackers)
        case .siriShortcuts:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_subtitle_siri)
        }
    }

    private func headertitle(for item: Section) -> String {
        switch item {
        case .general:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_general_settings)
        case .custom:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_custom_settings)
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
