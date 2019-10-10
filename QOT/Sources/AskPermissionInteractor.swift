//
//  AskPermissionInteractor.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import UIKit

final class AskPermissionInteractor {

    // MARK: - Properties
    private let worker: AskPermissionWorker
    private let presenter: AskPermissionPresenterInterface
    private let router: AskPermissionRouterInterface

    // MARK: - Init
    init(worker: AskPermissionWorker,
         presenter: AskPermissionPresenterInterface,
         router: AskPermissionRouterInterface) {
        self.worker = worker
        self.presenter = presenter
        self.router = router
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getPermissionContent { [weak self] (contentCollection, type) in
            self?.presenter.setupView(contentCollection, type: type)
        }
    }
}

// MARK: - AskPermissionInteractorInterface
extension AskPermissionInteractor: AskPermissionInteractorInterface {
    var permissionType: AskPermission.Kind {
        return worker.getPermissionType
    }

    var placeholderImage: UIImage? {
        let image: UIImage?
        switch worker.getPermissionType {
        case .notification, .notificationOpenSettings: image = R.image.notification_permission()
        case .location: image = R.image.location_permission()
        case .calendar, .calendarOpenSettings: image = R.image.calendar_permission()
        return image
    }

    func didTapSkip() {
        router.didTapDismiss(worker.getPermissionType)
    }

    func didTapConfirm() {
        router.didTapConfirm(worker.getPermissionType)
    }
}
