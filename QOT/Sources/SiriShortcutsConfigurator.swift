//
//  SiriShortcutsConfigurator.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SiriShortcutsConfigurator: AppStateAccess {

    static func make() -> (SiriShortcutsViewController) -> Void {
        return { (siriShortcutsViewController) in
            let router = SiriShortcutsRouter(siriShortcutsViewController: siriShortcutsViewController, services: appState.services)
            let presenter = SiriShortcutsPresenter(viewController: siriShortcutsViewController)
            let worker = SiriShortcutsWorker(services: appState.services)
            let interactor = SiriShortcutsInteractor(worker: worker, router: router, presenter: presenter)
            siriShortcutsViewController.interactor = interactor
        }
    }
}
