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
