//
//  MyQotSiriShortcutsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 14.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotSiriShortcutsInteractor {
    // MARK: - Properties

    private let worker: MyQotSiriShortcutsWorker
    private let presenter: MyQotSiriShortcutsPresenterInterface
    private let router: MyQotSiriShortcutsRouterInterface

    // MARK: - Init

    init(worker: MyQotSiriShortcutsWorker,
         presenter: MyQotSiriShortcutsPresenterInterface,
         router: MyQotSiriShortcutsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }
}

extension MyQotSiriShortcutsInteractor: MyQotSiriShortcutsInteractorInterface {

    func shortcutType(for indexPath: IndexPath) -> SiriShortcutsModel.Shortcut {
        return worker.shortcutType(for: indexPath)
    }

    func itemsCount() -> Int {
        return worker.itemsCount()
    }

    func trackingKey(for indexPath: IndexPath) -> String {
        return worker.trackingKey(for: indexPath)
    }

    func title(for indexPath: IndexPath) -> String {
        return worker.title(for: indexPath)
    }

    func handleTap(for shortcut: SiriShortcutsModel.Shortcut?) {
        router.handleTap(for: shortcut)
    }

    func siriShortcutsHeaderText(_ completion: @escaping(String) -> Void) {
        worker.siriShortcutsHeaderText { (text) in
            completion(text)
        }
    }

    func viewDidLoad() {
        worker.getData {[weak self] in
            self?.presenter.setupView()
        }
    }

    func sendSiriRecordingAppEvent(shortcutType: ShortcutType) {
        worker.sendSiriRecordingAppEvent(shortcutType: shortcutType)
    }
}
