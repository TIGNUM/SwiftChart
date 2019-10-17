//
//  MyQotSiriShortcutsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation
import qot_dal

final class MyQotSiriShortcutsWorker {

    // MARK: - Properties

    private let contentService: qot_dal.ContentService
    private var shortcutModel = SiriShortcutsModel(explanation: nil, shortcuts: [])
    private let dispatchGroup = DispatchGroup()

    private var toBeVisionModel = SiriShortcutsModel.Shortcut.defaultModel(type: .toBeVision)
    private var morningInterviewModel = SiriShortcutsModel.Shortcut.defaultModel(type: .morningInterview)
    private var whatsHotModel = SiriShortcutsModel.Shortcut.defaultModel(type: .whatsHot)

    // MARK: - Init

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    // MARK: - Functions

    func getData(_ completion: @escaping() -> Void) {
        siriShortcuts { [weak self] (model) in
            self?.shortcutModel = model
            completion()
        }
    }

    private func siriShortcuts(_ completion: @escaping(SiriShortcutsModel) -> Void) {
        toBeVisionModel = toBeVisionSiriModel
        morningInterviewModel = morningInterviewSiriModel
        whatsHotModel = whatsHotSiriModel

        dispatchGroup.notify(queue: .main) {
            let shortcuts: [SiriShortcutsModel.Shortcut]  = [self.toBeVisionModel,
                                                             self.morningInterviewModel,
                                                             self.whatsHotModel]
            let model = SiriShortcutsModel(explanation: nil, shortcuts: shortcuts)
            completion(model)
        }
    }

    var toBeVisionSiriModel: SiriShortcutsModel.Shortcut {
        let model = SiriShortcutsModel.Shortcut(type: .toBeVision,
                                           title: siriTitle(for: .toBeVision),
                                           trackingKey: siriTrackingKey(for: .toBeVision),
                                           suggestion: siriSuggestionPhrase(for: .toBeVision))
        return model
    }

    var morningInterviewSiriModel: SiriShortcutsModel.Shortcut {
        let model = SiriShortcutsModel.Shortcut(type: .morningInterview,
                                           title: siriTitle(for: .morningInterview),
                                           trackingKey: siriTrackingKey(for: .morningInterview),
                                           suggestion: siriSuggestionPhrase(for: .morningInterview))
        return model
    }

    var whatsHotSiriModel: SiriShortcutsModel.Shortcut {
        let model = SiriShortcutsModel.Shortcut(type: .whatsHot,
                                           title: siriTitle(for: .whatsHot),
                                           trackingKey: siriTrackingKey(for: .whatsHot),
                                           suggestion: siriSuggestionPhrase(for: .whatsHot))
        return model
    }

    func sendSiriRecordingAppEvent(shortcutType: ShortcutType) {
        var userEventTrack = QDMUserEventTracking()
        userEventTrack.action = .SIRI_DONATED
        switch shortcutType {
        case .toBeVision: userEventTrack.name = .SIRI_TO_BE_VISION
        case .morningInterview: userEventTrack.name = .SIRI_DAILY_CHECK_IN
        case .whatsHot: userEventTrack.name = .SIRI_WHATS_HOT
        }
        NotificationCenter.default.post(name: .reportUserEvent, object: userEventTrack)
    }

    func trackingKey(for indexPath: IndexPath) -> String {
        return shortcutModel.shortcuts[indexPath.row].trackingKey ?? ""
    }

    func title(for indexPath: IndexPath) -> String {
         return shortcutModel.shortcuts[indexPath.row].title ?? ""
    }

    func itemsCount() -> Int {
        return shortcutModel.shortcuts.count
    }

    func shortcutType(for indexPath: IndexPath) -> SiriShortcutsModel.Shortcut {
        return shortcutModel.shortcuts[indexPath.row]
    }

    var siriShortcutsHeaderText: String {
        return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_view_title_siri)
    }
}

extension MyQotSiriShortcutsWorker {
    func siriTag(for shortcut: ShortcutType) -> Tags {
        switch shortcut {
        case .toBeVision:
            return Tags.MyQOTSiriToBeVisionTitle
        case .whatsHot:
            return Tags.MyQOTSiriWhatsHotTitle
        case .morningInterview:
            return Tags.MyQOTSiriDailyPrepTitle
        }
    }

    func siriTrackingKey(for shortcut: ShortcutType) -> String? {
        return siriTag(for: shortcut).rawValue
    }

    func siriTitle(for shortcut: ShortcutType) -> String {
        switch shortcut {
        case .toBeVision:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts_view_title_tobevision)
        case .whatsHot:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts_view_title_whatshot)
        case .morningInterview:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts_view_title_daily_prep)
        }
    }

    func siriSuggestionPhrase(for shortcut: ShortcutType) -> String {
        switch shortcut {
        case .toBeVision:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts_view_body_tobevision)
        case .whatsHot:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts_view_body_whatshot)
        case .morningInterview:
            return AppTextService.get(AppTextKey.my_qot_my_profile_app_settings_siri_shortcuts_view_body_daily_prep)
        }
    }
}
