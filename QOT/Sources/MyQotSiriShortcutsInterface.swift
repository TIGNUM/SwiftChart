//
//  MyQotSiriShortcutsInterface.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

protocol MyQotSiriShortcutsViewControllerInterface: class {
    func setupView()
}

protocol MyQotSiriShortcutsPresenterInterface {
    func setupView()
}

protocol MyQotSiriShortcutsInteractorInterface: Interactor {
    func trackingKey(for indexPath: IndexPath) -> String
    func shortcutType(for indexPath: IndexPath) -> SiriShortcutsModel.Shortcut
    func title(for indexPath: IndexPath) -> String
    func siriShortcutsHeaderText(_ completion: @escaping(String) -> Void)
    func itemsCount() -> Int
    func handleTap(for shortcut: SiriShortcutsModel.Shortcut?)
    func sendSiriRecordingAppEvent(shortcutType: ShortcutType)
}

protocol MyQotSiriShortcutsRouterInterface {
    func handleTap(for shortcut: SiriShortcutsModel.Shortcut?)
}
