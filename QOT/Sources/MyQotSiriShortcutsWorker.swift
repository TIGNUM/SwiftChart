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
    private var upcomingEventModel = SiriShortcutsModel.Shortcut.defaultModel(type: .upcomingEventPrep)
    private var morningInterviewModel = SiriShortcutsModel.Shortcut.defaultModel(type: .morningInterview)
    private var whatsHotModel = SiriShortcutsModel.Shortcut.defaultModel(type: .whatsHot)

    // MARK: - Init

    init(contentService: qot_dal.ContentService) {
        self.contentService = contentService
    }

    // MARK: - Functions

    func getData(_ completion: @escaping() -> Void) {
        siriShortcuts { (model) in
            self.shortcutModel = model
            completion()
        }
    }

    private func siriShortcuts(_ completion: @escaping(SiriShortcutsModel) -> Void) {

        toBeVisionSiriModel {[weak self] (model) in
            self?.toBeVisionModel = model
        }

        upcomingEventPrepSiriModel {[weak self] (model) in
            self?.upcomingEventModel = model
        }

        morningInterviewSiriModel {[weak self] (model) in
            self?.morningInterviewModel = model
        }

        whatsHotSiriModel {[weak self] (model) in
            self?.whatsHotModel = model
        }

        dispatchGroup.notify(queue: .main) {
            let shortcuts: [SiriShortcutsModel.Shortcut]  = [self.toBeVisionModel,
                                                             self.upcomingEventModel,
                                                             self.morningInterviewModel,
                                                             self.whatsHotModel]
            let model = SiriShortcutsModel(explanation: nil, shortcuts: shortcuts)
            completion(model)
        }
    }

    func toBeVisionSiriModel(_ completion: @escaping(SiriShortcutsModel.Shortcut) -> Void) {
        dispatchGroup.enter()
        siriTitle(for: .toBeVision) {[weak self] (text) in
            self?.siriSuggestionPhrase(for: .toBeVision) {[weak self] (phrase) in
                let model = SiriShortcutsModel.Shortcut(type: .toBeVision,
                                                   title: text,
                                                   trackingKey: self?.siriTrackingKey(for: .toBeVision),
                                                   suggestion: phrase)
                completion(model)
                self?.dispatchGroup.leave()
            }
        }
    }

    func upcomingEventPrepSiriModel(_ completion: @escaping(SiriShortcutsModel.Shortcut) -> Void) {
        dispatchGroup.enter()
        siriTitle(for: .upcomingEventPrep) {[weak self] (text) in
            self?.siriSuggestionPhrase(for: .toBeVision) {[weak self] (phrase) in
                let model = SiriShortcutsModel.Shortcut(type: .upcomingEventPrep,
                                                   title: text,
                                                   trackingKey: self?.siriTrackingKey(for: .upcomingEventPrep),
                                                   suggestion: phrase)
                completion(model)
                self?.dispatchGroup.leave()
            }
        }
    }

    func morningInterviewSiriModel(_ completion: @escaping(SiriShortcutsModel.Shortcut) -> Void) {
        dispatchGroup.enter()
        siriTitle(for: .morningInterview) {[weak self] (text) in
            self?.siriSuggestionPhrase(for: .morningInterview) {[weak self] (phrase) in
                let model = SiriShortcutsModel.Shortcut(type: .morningInterview,
                                                   title: text,
                                                   trackingKey: self?.siriTrackingKey(for: .morningInterview),
                                                   suggestion: phrase)
                completion(model)
                self?.dispatchGroup.leave()
            }
        }
    }

    func whatsHotSiriModel(_ completion: @escaping(SiriShortcutsModel.Shortcut) -> Void) {
        dispatchGroup.enter()
        siriTitle(for: .whatsHot) {[weak self] (text) in
            self?.siriSuggestionPhrase(for: .whatsHot) {[weak self] (phrase) in
                let model = SiriShortcutsModel.Shortcut(type: .whatsHot,
                                                   title: text,
                                                   trackingKey: self?.siriTrackingKey(for: .whatsHot),
                                                   suggestion: phrase)
                completion(model)
                self?.dispatchGroup.leave()
            }
        }
    }

    func sendSiriRecordingAppEvent(shortcutType: ShortcutType) {
        switch shortcutType {
        case .toBeVision: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriToBeVisionDonated)
        case .morningInterview: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriDailyPrepDonated)
        case .whatsHot: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriWhatsHotDonated)
        case .upcomingEventPrep: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriUpcomingEventDonated)
        }
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

    func siriShortcutsHeaderText(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.AppSettings.Profile.siriShortcuts.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }
}

extension MyQotSiriShortcutsWorker {

    func siriExplanation(_ completion: @escaping(String) -> Void) {
        contentService.getContentItemByPredicate(ContentService.Siri.siriExplanation.predicate) {(contentItem) in
            completion(contentItem?.valueText ?? "")
        }
    }

    func siriTrackingKey(for shortcut: ShortcutType) -> String? {
        switch shortcut {
        case .toBeVision:
            return ContentService.Siri.siriToBeVisionTitle.rawValue
        case .upcomingEventPrep:
            return ContentService.Siri.siriUpcomingEventTitle.rawValue
        case .whatsHot:
            return ContentService.Siri.siriWhatsHotTitle.rawValue
        case .morningInterview:
            return ContentService.Siri.siriDailyPrepTitle.rawValue
        }
    }

    func siriTitle(for shortcut: ShortcutType, _ completion: @escaping(String) -> Void) {
        switch shortcut {
        case .toBeVision:
            contentService.getContentItemByPredicate(ContentService.Siri.siriToBeVisionTitle.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .upcomingEventPrep:
            contentService.getContentItemByPredicate(ContentService.Siri.siriUpcomingEventTitle.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .whatsHot:
            contentService.getContentItemByPredicate(ContentService.Siri.siriWhatsHotTitle.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .morningInterview:
            contentService.getContentItemByPredicate(ContentService.Siri.siriDailyPrepTitle.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        }
    }

    func siriSuggestionPhrase(for shortcut: ShortcutType, _ completion: @escaping(String) -> Void) {
        switch shortcut {
        case .toBeVision:
            contentService.getContentItemByPredicate(ContentService.Siri.siriToBeVisionSuggestionPhrase.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .upcomingEventPrep:
            contentService.getContentItemByPredicate(ContentService.Siri.siriUpcomingEventSuggestionPhrase.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .whatsHot:
            contentService.getContentItemByPredicate(ContentService.Siri.siriWhatsHotSuggestionPhrase.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        case .morningInterview:
            contentService.getContentItemByPredicate(ContentService.Siri.siriDailyPrepSuggestionPhrase.predicate) {(contentItem) in
                completion(contentItem?.valueText ?? "")
            }
        }
    }
}
