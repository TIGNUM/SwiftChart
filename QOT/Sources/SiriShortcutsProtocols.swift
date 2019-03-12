//
//  SiriShortcutsProtocols.swift
//  QOT
//
//  Created by Anais Plancoulaine on 08.02.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol SiriShortcutsViewControllerInterface: class {
    func setup(for shortcut: SiriShortcutsModel)
}

protocol SiriShortcutsPresenterInterface {
    func present(for shortcut: SiriShortcutsModel)
}

protocol SiriShortcutsInteractorInterface: Interactor {
    func handleTap(for shortcut: SiriShortcutsModel.Shortcut?)
    func sendSiriRecordingAppEvent(shortcutType: ShortcutType)
}

protocol SiriShortcutsRouterInterface {
    func handleTap(for shortcut: SiriShortcutsModel.Shortcut?)
}
