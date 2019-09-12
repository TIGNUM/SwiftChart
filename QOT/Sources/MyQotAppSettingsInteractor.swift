//
//  MyQotAppSettingsInteractor.swift
//  QOT
//
//  Created by Ashish Maheshwari on 10.05.19.
//  Copyright © 2019 Tignum. All rights reserved.
//

import Foundation

final class MyQotAppSettingsInteractor {

    // MARK: - Properties

    private let worker: MyQotAppSettingsWorker
    private let presenter: MyQotAppSettingsPresenterInterface
    private let router: MyQotAppSettingsRouterInterface

    // MARK: - Init

    init(worker: MyQotAppSettingsWorker,
         presenter: MyQotAppSettingsPresenterInterface,
         router: MyQotAppSettingsRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    func viewDidLoad() {
        presenter.present(worker.settings())
    }

    var appSettingsText: String {
        return worker.appSettingsText
    }
}

// MARK: - MyQotAppSettingsInteractorInterface

extension MyQotAppSettingsInteractor: MyQotAppSettingsInteractorInterface {

    func handleTap(setting: MyQotAppSettingsModel.Setting) {
        switch setting {
        case .notifications:
            router.openAppSettings()
        case .permissions:
            router.openAppSettings()
        case .calendars:
            handleCalendarTap()
        case .sensors:
            router.openActivityTrackerSettings()
        case .siriShortcuts:
            router.openSiriSettings()
        }
    }
}

// MARK: - Private methods

extension MyQotAppSettingsInteractor {
    func handleCalendarTap() {
        switch worker.calendarAuthorizationStatus {
        case .authorized:
            router.openCalendarSettings()
        case .notDetermined:
            router.openCalendarPermission(.calendar, delegate: self)
        case .denied, .restricted:
            router.openCalendarPermission(.calendarOpenSettings, delegate: self)
        }
    }
}

// MARK: - AskPermissionDelegate

extension MyQotAppSettingsInteractor: AskPermissionDelegate {
    func didFinishAskingForPermission(type: AskPermission.Kind, granted: Bool) {
        guard granted else { return }
        router.openCalendarSettings()
    }
}
