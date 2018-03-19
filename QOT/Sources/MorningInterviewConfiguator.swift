//
//  MorningInterviewConfiguator.swift
//  QOT
//
//  Created by Sam Wyndham on 19/02/2018.
//  Copyright © 2018 Tignum. All rights reserved.
//

import Foundation

final class MorningInterviewConfigurator: AppStateAccess {
    static func make(questionGroupID: Int, notificationRemoteID: Int) -> Configurator<MorningInterviewViewController> {
        return { viewController in
            let router = MorningInterviewRouter(viewController: viewController, appCoordinator: appState.appCoordinator)
            let presenter = MorningInterviewPresenter(viewController: viewController)
            let guideWorker = GuideWorker(services: appState.services) // FIXME: Shouldn't couple this to guide
            let worker = MorningInterviewWorker(services: appState.services,
                                                questionGroupID: questionGroupID,
                                                notificationRemoteID: notificationRemoteID,
                                                guideWorker: guideWorker,
                                                networkManager: appState.networkManager)
            let interactor = MorningInterviewInteractor(presenter: presenter, worker: worker)
            viewController.interactor = interactor
            viewController.router = router
        }
    }
}
