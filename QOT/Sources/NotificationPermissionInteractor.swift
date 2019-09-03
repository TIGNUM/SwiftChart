//
//  NotificationPermissionInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class NotificationPermissionInteractor {

    // MARK: - Properties

    private let worker: NotificationPermissionWorker
    private let presenter: NotificationPermissionPresenterInterface
    private let router: NotificationPermissionRouterInterface
    private let permissionManager: PermissionsManager

    // MARK: - Init

    init(worker: NotificationPermissionWorker,
        presenter: NotificationPermissionPresenterInterface,
        router: NotificationPermissionRouterInterface,
        permissionManager: PermissionsManager) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
        self.permissionManager = permissionManager
    }

    // MARK: - Interactor

    func viewDidLoad() {
        presenter.setupView()
    }

    // MARK: - Texts

    var title: String {
        return worker.title
    }

    var descriptionText: String {
        return worker.descriptionText
    }

    var skipButton: String {
        return worker.skipButton
    }

    var allowButton: String {
        return worker.allowButton
    }

    var permissionDeniedMessage: String {
        return worker.permissionDeniedMessage
    }

    var alertSettingsButton: String {
        return worker.alertSettingsButton
    }

    var alertSkipButton: String {
        return worker.alertSkipButton
    }
}

// MARK: - NotificationPermissionInteractorInterface

extension NotificationPermissionInteractor: NotificationPermissionInteractorInterface {
    func didTapSkip() {
        router.dismiss()
    }

    func didTapAllow() {
        worker.requestNotificationAccess { [weak self] (status) in
            if case .granted = status {
                self?.router.dismiss()
            } else {
                self?.presenter.presentDeniedPermissionAlert()
            }
        }
    }

    func didTapSettings() {
        router.openSettings()
    }
}
