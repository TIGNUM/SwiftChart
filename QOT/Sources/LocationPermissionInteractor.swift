//
//  LocationPermissionInteractor.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class LocationPermissionInteractor {

    // MARK: - Properties

    private let worker: LocationPermissionWorker
    private let presenter: LocationPermissionPresenterInterface
    private let router: LocationPermissionRouterInterface
    private let permissionManager: PermissionsManager

    // MARK: - Init

    init(worker: LocationPermissionWorker,
        presenter: LocationPermissionPresenterInterface,
        router: LocationPermissionRouterInterface,
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

// MARK: - LocationPermissionInteractorInterface

extension LocationPermissionInteractor: LocationPermissionInteractorInterface {
    func didTapSkip() {
        router.dismiss()
    }

    func didTapAllow() {
        worker.requestLocationAccess { [weak self] (status) in
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
