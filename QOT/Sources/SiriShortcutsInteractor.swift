//
//  SiriShortcutsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SiriShortcutsInteractor {

    // MARK: - Properties

    private let worker: SiriShortcutsWorker
    private let router: SiriShortcutsRouterInterface
    private let presenter: SiriShortcutsPresenterInterface

    // MARK: - Init

    init(worker: SiriShortcutsWorker, router: SiriShortcutsRouterInterface, presenter: SiriShortcutsPresenterInterface) {
        self.worker = worker
        self.router = router
        self.presenter = presenter
    }

    // MARK: - Lifecycle

    func viewDidLoad() {
        presenter.present(for: worker.siriShortcuts())
    }
}

// MARK: - SettingsInteractor interface

extension SiriShortcutsInteractor: SiriShortcutsInteractorInterface {

    func handleTap(for shortcut: SiriShortcutsModel.Shortcut) {
        router.handleTap(for: shortcut)
    }
}
