//
//  MyQotSiriShortcutsWorker.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSiriShortcutsWorker {

    // MARK: - Properties

    private let services: Services
    private var shortcutModel = SiriShortcutsModel(explanation: nil, shortcuts: [])

    // MARK: - Init

    init(services: Services) {
        self.services = services
        self.shortcutModel = siriShortcuts()
    }

    // MARK: - Functions

    func siriShortcuts() -> SiriShortcutsModel {
        let shortcuts = ShortcutType.allCases.map {
            return SiriShortcutsModel.Shortcut(type: $0,
                                               title: services.contentService.siriTitle(for: $0),
                                               trackingKey: services.contentService.siriTrackingKey(for: $0),
                                               suggestion: services.contentService.siriSuggestionPhrase(for: $0)) }
        return SiriShortcutsModel(explanation: nil, shortcuts: shortcuts)
    }

    func sendSiriRecordingAppEvent(shortcutType: ShortcutType) {
        switch shortcutType {
        case .toBeVision:
            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriToBeVisionDonated)
        case .morningInterview:
            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriDailyPrepDonated)
        case .whatsHot:
            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriWhatsHotDonated)
        case .upcomingEventPrep:
            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriUpcomingEventDonated)
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

    var siriShortcutsHeaderText: String {
        return services.contentService.localizedString(for: ContentService.AppSettings.Profile.siriShortcuts.predicate) ?? ""
    }
}
