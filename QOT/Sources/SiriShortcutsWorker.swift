//
//  SiriShortcutsWorker.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SiriShortcutsWorker {

    // MARK: - Properties

    private let services: Services

    // MARK: - Init

    init(services: Services) {
        self.services = services
    }

    // MARK: - Functions

    func siriShortcuts() -> SiriShortcutsModel {
        let explanation = services.contentService.siriExplanation()
        let shortcuts = ShortcutType.allCases.map {
            return SiriShortcutsModel.Shortcut(type: $0,
                                               title: services.contentService.siriTitle(for: $0),
                                               suggestion: services.contentService.siriSuggestionPhrase(for: $0)) }
        return SiriShortcutsModel(explanation: explanation, shortcuts: shortcuts)
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
}
