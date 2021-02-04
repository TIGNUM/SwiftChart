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

    // MARK: - Init
    init(presenter: NotificationSettingsPresenterInterface) {
        self.presenter = presenter
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

}
