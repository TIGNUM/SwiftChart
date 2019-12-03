//
//  AskPermissionInteractor.swift
//  QOT
//
//  Created by karmic on 26.08.19.
//  Copyright (c) 2019 Tignum. All rights reserved.
//

import qot_dal

final class AskPermissionInteractor {

    // MARK: - Properties
    private lazy var worker = AskPermissionWorker(contentService: ContentService.main)
    private let presenter: AskPermissionPresenterInterface
    private let permissionType: AskPermission.Kind

    // MARK: - Init
    init(presenter: AskPermissionPresenterInterface, permissionType: AskPermission.Kind) {
        self.presenter = presenter
        self.permissionType = permissionType
    }

    // MARK: - Interactor
    func viewDidLoad() {
        worker.getPermissionContent(permissionType: permissionType) { [weak self] (contentCollection) in
            self?.presenter.setupView(contentCollection, type: self?.permissionType)
        }
    }
}

// MARK: - AskPermissionInteractorInterface
extension AskPermissionInteractor: AskPermissionInteractorInterface {
    var placeholderImage: UIImage? {
        let image: UIImage?
        switch permissionType {
        case .notification, .notificationOnboarding, .notificationOpenSettings: image = R.image.notification_permission()
        case .location: image = R.image.location_permission()
        case .calendar, .calendarOpenSettings: image = R.image.calendar_permission()
        }
        return image
    }

    var getPermissionType: AskPermission.Kind {
        return permissionType
    }
}
