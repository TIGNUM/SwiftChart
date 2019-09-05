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
        // FIXME: THIS VIEW CONTROLLER IS NOT USED
        switch shortcutType {
        case .toBeVision: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriToBeVisionDonated)
        case .morningInterview: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriDailyPrepDonated)
        case .whatsHot: break
//            AppCoordinator.appState.appCoordinator.sendAppEvent(.siriWhatsHotDonated)
        }
    }
}
