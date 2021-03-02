//
//  NotificationSettingsInteractor.swift
//  QOT
//
//  Created by Anais Plancoulaine on 03.02.21.
//  Copyright (c) 2021 Tignum. All rights reserved.
//

import UIKit

final class NotificationSettingsInteractor {

    // MARK: - Properties
    private lazy var worker = NotificationSettingsWorker()
    private let presenter: NotificationSettingsPresenterInterface!
    private let router: NotificationSettingsRouterInterface

    // MARK: - Init
    init(presenter: NotificationSettingsPresenterInterface,
         router: NotificationSettingsRouterInterface) {
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        presenter.present()
    }

    var notificationsTitle: String {
        return worker.notificationsTitle
    }
    var notificationsSubtitle: String {
        return worker.notificationsSubtitle
    }
}

// MARK: - NotificationSettingsInteractorInterface
extension NotificationSettingsInteractor: NotificationSettingsInteractorInterface {

    func handleTap(setting: NotificationSettingsModel.Setting) {
        switch setting {
        case .dailyReminders:
            router.didTapDailyReminders()
        default:
            break
        }
    }
}
