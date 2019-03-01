//
//  SiriShortcutsPresenter.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class SiriShortcutsPresenter {

    // MARK: - Properties

    private weak var viewController: SiriShortcutsViewControllerInterface?

    // MARK: - Init

    init(viewController: SiriShortcutsViewControllerInterface) {
        self.viewController = viewController
    }
}

// MARK: - SettingsPresenterInterface

extension SiriShortcutsPresenter: SiriShortcutsPresenterInterface {

    func present(for shortcut: SiriShortcutsModel) {
        viewController?.setup(for: shortcut)
    }
}
