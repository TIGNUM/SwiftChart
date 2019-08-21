//
//  LocationPermissionInterface.swift
//  QOT
//
//  Created by Zeljko Zivkovic on 14/08/2019.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import Foundation

protocol LocationPermissionViewControllerInterface: class {
    func setupView()
    func presentDeniedPermissionAlert()
}

protocol LocationPermissionPresenterInterface {
    func setupView()
    func presentDeniedPermissionAlert()
}

protocol LocationPermissionInteractorInterface: Interactor {
    var title: String { get }
    var descriptionText: String { get }
    var skipButton: String { get }
    var allowButton: String { get }
    var permissionDeniedMessage: String { get }
    var alertSettingsButton: String { get }
    var alertSkipButton: String { get }

    func didTapSkip()
    func didTapAllow()
    func didTapSettings()
}

protocol LocationPermissionRouterInterface {
    func dismiss()
    func openSettings()
}
